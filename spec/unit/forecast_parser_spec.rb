require 'spec_helper'

module Weathervision
  describe ForecastParser do
    let(:test_options_image) { { "fc_query" => "Utrecht", "c_query" => "IUTRECHT23", "mode" => "image", "radar_url" => "http://www.knmi.nl/neerslagradar/images/meest_recente_radarloop451.gif"} }
    let(:test_options_image_without_radar) { { "fc_query" => "Utrecht", "c_query" => "IUTRECHT23", "mode" => "image", "radar_url" => nil } }
    let(:test_options_text) { { "fc_query" => "Utrecht", "c_query" => "IUTRECHT37", "mode" => "text", "radar_url" => "http://www.knmi.nl/neerslagradar/images/meest_recente_radarloop451.gif"} }

    it "should have a template which outputs paths to images" do
      parser = ForecastParser.new(test_options_image)
      parser.parse
      parser.conky_ouput.should include(".png")
    end

    it "should call the right image methods according the options hash" do
      parser = ForecastParser.new(test_options_image)
      parser.should_receive(:calc_weather_icon).with(:image).once
      parser.should_receive(:calc_wind_icon).once
      parser.parse
    end

    it "should call the right text method according the options hash" do
      parser = ForecastParser.new(test_options_text)
      parser.should_receive(:calc_weather_icon).with(:text).once
      parser.should_not_receive(:calc_wind_icon)
      parser.parse
    end

    it "should extract the wind speed from a text node and return an integer respresenting kph" do
      parser = ForecastParser.new(test_options_image)
      parser.extract_wind_speed("Clear. High 28&amp;deg;C (82&amp;deg;F). Winds 10 kph SSE").should == 10
      parser.extract_wind_speed("Clear. High 28&amp;deg;C (82&amp;deg;F). No Winds today, sorry.").should == 0
      parser.extract_wind_speed("Winds 30 MPH West. Thunderstorms. High18&amp;deg;C").should == 48
    end

    it "should extract the wind direction from a text node and return it as a string" do
      parser = ForecastParser.new(test_options_image)
      parser.extract_wind_direction("Clear. High 28&amp;deg;C (82&amp;deg;F). Winds 10 kph SSE").should == "SSE"
      parser.extract_wind_direction("Winds 30 MPH West. Thunderstorms. High18&amp;deg;C").should == "West"
      parser.extract_wind_direction("Mostly cloudy. Winds 22 kph North. Sometimes Thunderstorms. High18&amp;deg;C").should == "North"
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

  end
end
