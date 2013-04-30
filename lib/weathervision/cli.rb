module Weathervision
  class CLI < Thor

    desc "parse [options]", "Parse weather data" 
    method_option :mode, :type => :string, :required => true, :desc => "Mode: use 'vtext', 'htext', 'vimage' or 'himage'", :default => 'himage'
    method_option :apikey, :type => :string, :required => true, :desc => "wunderground.com json API key"
    method_option :current_location, :type => :string, :required => true, :desc => "wunderground.com current weather location query string", :default => 'vlist'
    method_option :forecast_location, :type => :string, :required => true, :desc => "wunderground.com forecast weather location query string", :default => 'vlist'
    method_option :radar_location, :type => :string, :required => false, :desc => "URL of a radar image (Animated GIF)", :default => "http://www.knmi.nl/neerslagradar/images/meest_recente_radarloop451.gif"
    def parse
      parser = Weathervision::ForecastParser.new(options)
      parser.parse
    end
  end
end

