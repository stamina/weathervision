require 'spec_helper'

module Weathervision
  describe ForecastParser do
    let(:test_options_image) { { "apikey" => ENV["apikey"], "mode" => "himage", "current_location" => "vlist", "forecast_location" => "vlist", "radar_location" => "http://www.knmi.nl/neerslagradar/images/meest_recente_radarloop451.gif"} }

    it "should parse a weather forecast feed over the internet" do
      doc = HTTParty.get("http://api.wunderground.com/api/#{test_options_image['apikey']}/conditions/lang:EN/q/#{test_options_image['current_location']}.json")
      doc.class.should ==  HTTParty::Response
    end

    it "should parse a weather current feed over the internet" do
      doc = HTTParty.get("http://api.wunderground.com/api/#{test_options_image['apikey']}/forecast10day/lang:EN/q/#{test_options_image['forecast_location']}.json")
      doc.class.should == HTTParty::Response
    end

    it "should download and manipulate a radar image" do
      parser = ForecastParser.new(test_options_image)
      parser.parse
      File.size?(RADAR_PATH + '/radar.gif').should_not be_nil
    end

    it "should cleanup temporary images" do
      parser = ForecastParser.new(test_options_image)
      parser.parse
      Dir.glob("#{RADAR_PATH}/*.gif").size.should == 1
    end

    it "should parse the forecast weather conditions" do
      parser = ForecastParser.new(test_options_image)
      parser.forecast_json = mock(HTTParty::Response).as_null_object
      parser.parse_forecast
    end

    it "should parse the current weather conditions" do
      parser = ForecastParser.new(test_options_image)
      parser.parse_json
      parser.parse_current
      parser.current.keys.size.should == 8
    end

  end
end
