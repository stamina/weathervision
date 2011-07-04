require "nokogiri"
require "open-uri"
require "thor"
require "erb"

require "pry"
require "ruby-debug"

require "weathervision/forecast_parser"
require "weathervision/cli"

module Weathervision
  RADAR_PATH = File.expand_path("../assets/radars", File.dirname(__FILE__))
  WEATHER_PATH = File.expand_path("../assets/images/weathericons", File.dirname(__FILE__))
  BEARING_PATH = File.expand_path("../assets/images/bearingicons", File.dirname(__FILE__))
  TEMPLATE_PATH = File.expand_path("../templates", File.dirname(__FILE__))
end

