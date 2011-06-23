class ForecastParser
  attr_reader :text_icons, :image_icons

  def initialize
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
  end

  def extract_wind_speed(text)
    if text.match(/(\d+)\s+(KPH|MPH)/i)
      speed, unit = $1, $2
      speed = speed.to_i * 1.605 if unit =~ /MPH/i
    end
    speed.to_i
  end

  def extract_wind_direction(text)
    ""
  end

end
