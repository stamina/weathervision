module Weathervision
  class ForecastParser
    attr_reader :text_icons, :image_icons, :forecast, :current

    def initialize(options)
      @forecast, @current, @params = {}, {}, {}
      @image_tpl = 'templates/weathervision_image.erb'
      @text_tpl = 'templates/weathervision_text.erb'
      @wind_icons = {
        "VAR" => { empty: "00", green: "01", yellow: "02", orange: "03", red: "04" },
        "North" => { empty: "00", green: "05", yellow: "21", orange: "37", red: "53" },
        "NNE" => { empty: "00", green: "06", yellow: "22", orange: "38", red: "54" },
        "NE" => { empty: "00", green: "07", yellow: "23", orange: "39", red: "55" },
        "ENE" => { empty: "00", green: "08", yellow: "24", orange: "40", red: "56" },
        "East" => { empty: "00", green: "09", yellow: "25", orange: "41", red: "57" },
        "ESE" => { empty: "00", green: "10", yellow: "26", orange: "42", red: "58" },
        "SE" => { empty: "00", green: "11", yellow: "27", orange: "43", red: "59" },
        "SSE" => { empty: "00", green: "12", yellow: "28", orange: "44", red: "60" },
        "South" => { empty: "00", green: "13", yellow: "29", orange: "45", red: "61" },
        "SSW" => { empty: "00", green: "14", yellow: "30", orange: "46", red: "62" },
        "SW" => { empty: "00", green: "15", yellow: "31", orange: "47", red: "63" },
        "WSW" => { empty: "00", green: "16", yellow: "32", orange: "48", red: "64" },
        "West" => { empty: "00", green: "17", yellow: "33", orange: "49", red: "65" },
        "WNW" => { empty: "00", green: "18", yellow: "34", orange: "50", red: "66" },
        "NW" => { empty: "00", green: "19", yellow: "35", orange: "51", red: "67" },
        "NNW" => { empty: "00", green: "20", yellow: "36", orange: "52", red: "68" }
      }
      @text_icons = {
        "Chance of Flurries" => "p",
        "Chance of Rain" => "h",
        "Chance of Freezing Rain" => "t",
        "Chance of Sleet" => "x",
        "Chance of Snow" => "p",
        "Chance of Thunderstorms" => "n",
        "Chance of a Thunderstorm" => "m",
        "Clear" => "a",
        "Cloudy" => "f",
        "Flurries" => "p",
        "Fog" => "0",
        "Haze" => "9",
        "Mostly Cloudy" => "d",
        "Mostly Sunny" => "b",
        "Partly Cloudy" => "c",
        "Partly Sunny" => "c",
        "Freezing Rain" => "v",
        "Rain" => "i",
        "Sleet" => "w",
        "Snow" => "q",
        "Sunny" => "a",
        "Thunderstorms" => "n",
        "Thunderstorm" => "m",
        "Unknown" => "?",
        "Overcast" => "e",
        "Scattered Clouds" => "d"
      }
      @image_icons = {
        "Chance of Flurries" => "13",
        "Chance of Rain" => "11",
        "Chance of Freezing Rain" => "10",
        "Chance of Sleet" => "18",
        "Chance of Snow" => "14",
        "Chance of Thunderstorms" => "38",
        "Chance of a Thunderstorm" => "38",
        "Clear" => "32",
        "Cloudy" => "26",
        "Flurries" => "13",
        "Fog" => "20",
        "Haze" => "21",
        "Mostly Cloudy" => "28",
        "Mostly Sunny" => "34",
        "Partly Cloudy" => "34",
        "Partly Sunny" => "30",
        "Freezing Rain" => "10",
        "Rain" => "12",
        "Sleet" => "18",
        "Snow" => "16",
        "Sunny" => "32",
        "Thunderstorms" => "3",
        "Thunderstorm" => "3",
        "Unknown" => "25",
        "Overcast" => "26",
        "Scattered Clouds" => "30"
      }
      @params["mode"] = options["mode"]
      @params["fc_query"] = options["fc_query"]
      @params["c_query"] = options["c_query"]
    end

    def parse
      parse_forecast && parse_current
      @params["mode"] == 'text' ? show_text_version : show_image_version
    end

    def show_image_version
      calc_weather_icon(:image)
      calc_wind_icon
      erb = ERB.new(File.read(@image_tpl))
      p erb.result(binding)
    end

    def show_text_version
      calc_weather_icon(:text)
      erb = ERB.new(File.read(@text_tpl))
      p erb.result(binding)
    end

    def calc_weather_icon(type)
      @forecast.keys.each do |period|
        if type == :image
          @forecast[period].merge!("weather_icon" => @image_icons[@forecast[period]["conditions"]] + ".png")
        elsif type == :text
          @forecast[period].merge!("weather_icon" => @text_icons[@forecast[period]["conditions"]])
        end
      end
    end

    def calc_wind_icon
      @forecast.keys.each do |period|
        if @forecast[period].keys.include?("windspeed")
          color = get_color @forecast[period]["windspeed"]
          @forecast[period].merge!("wind_icon" => @wind_icons[@forecast[period]["winddir"]][color] + ".png")
        end
      end
      color = get_color @current["windspeed"]
      @current.merge!("wind_icon" => @wind_icons[@current["winddir"]][color] + ".png")
    end

    def get_color windspeed
      color = case windspeed.to_i
        when 0 then :empty 
        when 1..19 then :green 
        when 20..25 then :yellow 
        when 26..39 then :orange
        when 40..256 then :red 
      else
       :empty 
      end
    end

    def parse_forecast
      @forecast_doc = Nokogiri::XML(open("http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=#{@params["fc_query"]}"))
      set = @forecast_doc.css('simpleforecast forecastday')
      set.each do |node|
        hsh = {}
        hsh['weekday'] = node.css("weekday").text
        hsh['high'] = node.css('high celsius').text
        hsh['low'] = node.css('low celsius').text
        hsh['conditions'] = node.css('conditions').text
        @forecast[node.css('period').text] = hsh
      end
      set = @forecast_doc.css('txt_forecast')
      @forecast.keys.each do |period|
        forecast_text = set.xpath("//forecastday[period=#{period}]/fcttext").first
        if !forecast_text.nil?
          @forecast[period].merge!({ "text" => forecast_text.text}) 
          @forecast[period].merge!({ "windspeed" => extract_wind_speed(forecast_text.text)})
          @forecast[period].merge!({ "winddir" => extract_wind_direction(forecast_text.text)})
        end
      end
    end

    def parse_current
      @current_doc = Nokogiri::XML(open("http://api.wunderground.com/weatherstation/WXCurrentObXML.asp?ID=#{@params["c_query"]}"))
      node = @current_doc.css('current_observation').first
      @current['city'] = node.css('city').text
      @current['temp'] = node.css('temp_c').text
      @current['updated'] = node.css("observation_time_rfc822").text
      @current['windspeed'] = (node.css('wind_mph').text.to_i * 1.605).to_s
      @current['winddir'] = node.css('wind_dir').text
      @current['winddegrees'] = node.css('wind_degrees').text
      @current['humidity'] = node.css('relative_humidity').text
      # fetch sunset from forecast xml
      node = @forecast_doc.css('moon_phase').first
      @current['sunset'] = node.css('sunset hour').text + ':' + node.css('sunset minute').text
    end

    def extract_wind_speed(text)
      speed = 0
      if text.match(/(\d+)\s+(KPH|MPH)/i)
        speed, unit = $1, $2
        speed = speed.to_i * 1.605 if unit =~ /MPH/i
      end
      speed.to_i
    end

    def extract_wind_direction(text)
      direction = "VAR"
      direction = $1 if text.match(/\s+(North|East|South|West)/i)
      direction = $1 if text.match(/\s+(NNE|NE|ENE|ESE|SE|SSE|SSW|SW|WSW|WNW|NW|NNW)/)
      direction
    end

  end
end
