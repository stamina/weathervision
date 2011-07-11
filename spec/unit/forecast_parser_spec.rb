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
      parser.extract_wind_speed("Clear. High 28&amp;deg;C (82&amp;deg;F). Winds 10 kph SSE").should == "10.0"
      parser.extract_wind_speed("Clear. High 28&amp;deg;C (82&amp;deg;F). No Winds today, sorry.").should == "0.0"
      parser.extract_wind_speed("Winds 30 MPH West. Thunderstorms. High18&amp;deg;C").should == "48.1"
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

    it "should return the right color symbols for the wind speed" do
      parser = ForecastParser.new(test_options_image)
      parser.get_color("100").should == :red
      parser.get_color(0.2).should == :empty
      parser.get_color("1024").should == :empty
      parser.get_color(20.234).should == :yellow
      parser.get_color("13.5").should == :green
    end

    it "should return a wind direction" do
      parser = ForecastParser.new(test_options_image)
      parser.extract_wind_direction("The wind seems North").should == "North"
      parser.extract_wind_direction("Rain and a SSE wind.").should == "SSE"
      parser.extract_wind_direction("I cannot feel the wind").should == "VAR"
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
      parser.calc_weather_icon(:image)
      parser.forecast["0"]["weather_icon"].should =~ /20\.png/
      parser.calc_weather_icon(:text)
      parser.forecast["0"]["weather_icon"].should =~ /0/
    end

  end
end
