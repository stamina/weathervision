require 'spec_helper'

module Weathervision
  describe ForecastParser do
    let(:test_options_image) { { "apikey" => ENV["apikey"], "mode" => "himage", "current_location" => "vlist", "forecast_location" => "vlist", "radar_location" => "http://www.knmi.nl/neerslagradar/images/meest_recente_radarloop451.gif"} }
    let(:test_options_image_without_radar) { { "apikey" => ENV["apikey"], "mode" => "himage", "current_location" => "vlist", "forecast_location" => "vlist", "radar_location" => ""} }

    it "should have a template which outputs paths to images" do
      parser = ForecastParser.new(test_options_image)
      parser.parse
      parser.conky_output.should include(".png")
    end

    it "should call the right image methods according the options hash" do
      parser = ForecastParser.new(test_options_image)
      parser.should_receive(:calc_weather_icon).once
      parser.should_receive(:calc_wind_icon).once
      parser.parse
    end

    it "should process a radar image if set" do
      parser = ForecastParser.new(test_options_image)
      parser.should_receive(:parse_radar).once
      parser.parse
    end

    it "should not process a radar image when disabled" do
      parser = ForecastParser.new(test_options_image_without_radar)
      parser.should_not_receive(:parse_radar)
      parser.parse
    end

    it "should return the right color symbols for the wind speed" do
      parser = ForecastParser.new(test_options_image)
      parser.get_color("100").should == :red
      parser.get_color(0.2).should == :empty
      parser.get_color("1024").should == :empty
      parser.get_color(20.234).should == :yellow
      parser.get_color("13.5").should == :green
    end

    it "should merge the right wind icon name" do
      parser = ForecastParser.new(test_options_image)  
      parser.instance_eval { @forecast = { "0" => { "windspeed" => "1", "winddir" => "East" } } }
      parser.instance_eval { @current = { "windspeed" => "30", "winddir" => "NW" } }
      parser.calc_wind_icon
      parser.current["wind_icon"].should =~ /51\.png/
      parser.forecast["0"]["wind_icon"].should =~ /09\.png/
    end

    it "should merge the right weather icon name" do
      parser = ForecastParser.new(test_options_image)  
      parser.instance_eval { @forecast = { "0" => { "conditions" => "Fog" } } }
      parser.calc_weather_icon
      parser.forecast["0"]["weather_icon"].should =~ /20\.png/
    end

    it "should take a default icon when unknown weather conditions" do
      parser = ForecastParser.new(test_options_image)  
      parser.instance_eval { @forecast = { "0" => { "conditions" => "Change Rain" } } }
      parser.calc_weather_icon
      parser.forecast["0"]["weather_icon"].should =~ /25\.png/
    end

  end
end
