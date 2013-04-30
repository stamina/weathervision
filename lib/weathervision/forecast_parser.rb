module Weathervision #:nodoc:

  # The main weather parsing class
  class ForecastParser
    attr_reader :text_icons, :image_icons, :forecast, :current, :conky_ouput, :radar
    attr_accessor :forecast_json, :current_json, :astronomy_json

    # Constructor method: predefines the data hashes and sets the user's options coming in
    # from Thor's cli api
    def initialize(options)
      @forecast, @current, @radar, @options = {}, {}, nil, options
      @himage_tpl = "#{TEMPLATE_PATH}/weathervision_himage.erb"
      @vimage_tpl = "#{TEMPLATE_PATH}/weathervision_vimage.erb"
      @htext_tpl = "#{TEMPLATE_PATH}/weathervision_htext.erb"
      @vtext_tpl = "#{TEMPLATE_PATH}/weathervision_vtext.erb"
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
      @wind_arrows = {
        "VAR" => { empty: "%", green: "!", yellow: '"', orange: "#", red: "$" },
        "North" => { empty: "%", green: "1", yellow: "A", orange: "Q", red: "a" },
        "NNE" => { empty: "%", green: "2", yellow: "B", orange: "R", red: "b" },
        "NE" => { empty: "%", green: "3", yellow: "C", orange: "S", red: "c" },
        "ENE" => { empty: "%", green: "4", yellow: "D", orange: "T", red: "d" },
        "East" => { empty: "%", green: "5", yellow: "E", orange: "U", red: "e" },
        "ESE" => { empty: "%", green: "6", yellow: "F", orange: "V", red: "f" },
        "SE" => { empty: "%", green: "7", yellow: "G", orange: "W", red: "g" },
        "SSE" => { empty: "%", green: "8", yellow: "H", orange: "X", red: "h" },
        "South" => { empty: "%", green: "9", yellow: "I", orange: "Y", red: "i" },
        "SSW" => { empty: "%", green: ":", yellow: "J", orange: "Z", red: "j" },
        "SW" => { empty: "%", green: ";", yellow: "K", orange: "[", red: "k" },
        "WSW" => { empty: "%", green: "<", yellow: "L", orange: "\\", red: "l" },
        "West" => { empty: "%", green: "=", yellow: "M", orange: "]", red: "m" },
        "WNW" => { empty: "%", green: ">", yellow: "N", orange: "^", red: "n" },
        "NW" => { empty: "%", green: "?", yellow: "O", orange: "_", red: "o" },
        "NNW" => { empty: "%", green: "@", yellow: "P", orange: "`", red: "p" }
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
        "Thunderstorms" => "03",
        "Thunderstorm" => "03",
        "Unknown" => "25",
        "Overcast" => "26",
        "Scattered Clouds" => "30"
      }
    end

    # Main processing function which starts the actual parsing and displaying
    def parse
      parse_json && parse_forecast && parse_current
      (@options["mode"] =~ /text/).nil? ? show_image_version : show_text_version
    end

    # Final method which parses and outputs the image template
    def show_image_version
      if @options["mode"] == "himage"
        tpl = @himage_tpl
      elsif @options["mode"] == "vimage"
        tpl = @vimage_tpl
      else 
        raise "invalid template name" + @options["mode"]
      end
      calc_weather_icon(:image)
      calc_wind_icon
      parse_radar unless @options["radar_location"].nil?
      erb = ERB.new(File.read(tpl), 0, '>')
      @conky_ouput = erb.result(binding)
      puts @conky_ouput
    end

    # Final method which parses and outputs the text template
    def show_text_version
      if @options["mode"] == "htext"
        tpl = @htext_tpl
      elsif @options["mode"] == "vtext"
        tpl = @vtext_tpl
      else 
        raise "invalid template name" + @options["mode"]
      end
      calc_weather_icon(:text)
      calc_wind_arrow
      parse_radar unless @options["radar_location"].nil?
      erb = ERB.new(File.read(tpl), 0, '>')
      @conky_ouput = erb.result(binding)
      puts @conky_ouput
    end

    # Fetches the optional radar animated GIF
    # Imagemagick's convert tool is used to make it a cropped single image
    def parse_radar
      outfile = RADAR_PATH + "/radar_#{Time.now.to_i}_#{Time.now.strftime("%d%m%Y")}.gif"
      %x(wget #{@options["radar_location"]} -O #{outfile} 2>&1 >/dev/null)
      %x(convert #{outfile} -flatten -repage '0x0' -crop '259x357+89+0' +repage #{RADAR_PATH + '/radar.gif'})
      # clear temp files and assign latest radar image
      Dir.glob("#{RADAR_PATH}/*.gif") do |filename|
        if filename =~ /radar\.gif/
          @radar = filename
        else
          File.delete(filename)
        end
      end
    end

    # Fetches the right weather icon (an PNG image for the image version and a Font letter for the text version) and adds
    # it to the hashes
    def calc_weather_icon(type)
      @forecast.keys.each do |period|
        if type == :image
          @forecast[period].merge!("weather_icon" => WEATHER_PATH + "/" + (@image_icons[@forecast[period]["conditions"]] || @image_icons["Unknown"]) + ".png")
        elsif type == :text
          @forecast[period].merge!("weather_icon" => (@text_icons[@forecast[period]["conditions"]] || @text_icons["Unknown"]))
        end
      end
    end

    # Fetches the right wind icon name based on the wind direction and wind speed and adds
    # it to the hashes
    def calc_wind_icon
      @forecast.keys.each do |period|
        if @forecast[period].keys.include?("windspeed")
          color = get_color @forecast[period]["windspeed"]
          @forecast[period].merge!("wind_icon" => BEARING_PATH + "/" + (@wind_icons[@forecast[period]["winddir"]][color] || @wind_icons["VAR"][color])  + ".png")
        end
      end
      color = get_color @current["windspeed"]
      @current.merge!("wind_icon" => BEARING_PATH + "/" + (@wind_icons[@current["winddir"]][color] || @wind_icons["VAR"][color]) + ".png")
    end

    # Fetches the right wind arrow letter for the wind font based on the direction and adds it to the hashes
    def calc_wind_arrow
      @forecast.keys.each do |period|
        if @forecast[period].keys.include?("windspeed")
          color = get_color @forecast[period]["windspeed"]
          @forecast[period].merge!("wind_icon" => (@wind_arrows[@forecast[period]["winddir"]][color] || @wind_arrows["VAR"][color]))
        end
      end
      color = get_color @current["windspeed"]
      @current.merge!("wind_icon" => (@wind_arrows[@current["winddir"]][color] || @wind_arrows["VAR"][color]))
    end

    # Calculates the color to use as the arrow in the wind compass.
    # The numbers represent km/h:
    # 
    # * 0 means no wind
    # * 1 till 19 means light/gentle breeze
    # * 20 till 25 means moderate breeze
    # * 26 till 39 means fresh breeze
    # * 40 till 256 means strong wind, gale or even storms
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

    # Parses the forecast weather conditions json feed and fills @forecast with 
    # the upcoming weather conditions (including today)
    def parse_forecast
      @forecast_json["forecast"]["simpleforecast"]["forecastday"].each do |day|
        hsh = {}
        hsh['weekday'] = day["date"]["weekday_short"]
        hsh['high'] = day["high"]["celsius"]
        hsh['low'] = day["low"]["celsius"]
        hsh['conditions'] = day["conditions"]
        hsh['windspeed'] = day["maxwind"]["kph"]
        hsh['winddir'] = day["maxwind"]["dir"]
        @forecast[day["period"]] = hsh # periods 1 to 10
      end
    end

    # Parses the current weather condition json feed and fills @current with the data
    def parse_current
      attr = @current_json['current_observation']
      @current['city'] = attr['observation_location']['city']
      @current['temp'] = attr['temp_c'].to_s
      @current['windspeed'] = attr['wind_kph']
      @current['winddir'] = attr['wind_dir']
      @current['winddegrees'] = attr['wind_degrees']
      @current['humidity'] = attr['relative_humidity']
      moon = @astronomy_json['moon_phase']
      @current['sunrise'] = moon['sunrise']['hour'] +  ':' + moon['sunrise']['minute']
      @current['sunset'] = moon['sunset']['hour'] +  ':' + moon['sunset']['minute']
    end

    # Parses the actual json data and sets the instance variables
    def parse_json
      @current_json = HTTParty.get("http://api.wunderground.com/api/#{@options['apikey']}/conditions/lang:EN/q/#{@options['current_location']}.json")
      @astronomy_json = HTTParty.get("http://api.wunderground.com/api/#{@options['apikey']}/astronomy/lang:EN/q/#{@options['current_location']}.json")
      @forecast_json = HTTParty.get("http://api.wunderground.com/api/#{@options['apikey']}/forecast10day/lang:EN/q/#{@options['forecast_location']}.json")
    end

  end
end
