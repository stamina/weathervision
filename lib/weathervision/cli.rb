module Weathervision
  class CLI < Thor

    desc "parse [options]", "Parse weather data" 
    method_option :mode, :type => :string, :required => true, :desc => "Mode: use 'text' or 'image'", :default => 'image'
    method_option :fc_query, :type => :string, :required => true, :desc => "Weather forecast query string", :default => 'Utrecht'
    method_option :c_query, :type => :string, :required => true, :desc => "Weather current query sring", :default => 'IUTRECHT23'
    method_option :radar_url, :type => :string, :required => false, :desc => "URL of a radar image, use --no-radar-url to skip this feature", :default => 'http://www.knmi.nl/neerslagradar/images/meest_recente_radarloop451.gif'
    def parse
      parser = Weathervision::ForecastParser.new(options)
      parser.parse
    end

  end
end

