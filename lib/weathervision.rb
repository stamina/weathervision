#external deps
require "nokogiri"
require "open-uri"
require "thor"
require "erb"

#debugging deps
require "pry"
require "ruby-debug"
require "ruby-debug/pry"

#internal deps
require "weathervision/forecast_parser"
require "weathervision/cli"

#wrapping namespace
module Weathervision
  # constant variable pointing to the absolute path where the (optional) radar image will be saved 
  RADAR_PATH = File.expand_path("../assets/radars", File.dirname(__FILE__))
  # constant variable pointing to the absolute path where the weather icons are
  WEATHER_PATH = File.expand_path("../assets/images/weathericons", File.dirname(__FILE__))
  # constant variable pointing to the absolute path where the wind icons are
  BEARING_PATH = File.expand_path("../assets/images/bearingicons", File.dirname(__FILE__))
  # constant variable pointing to the absolute path where the image and text templates are
  TEMPLATE_PATH = File.expand_path("../templates", File.dirname(__FILE__))
end

