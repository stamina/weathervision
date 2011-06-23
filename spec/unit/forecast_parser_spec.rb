require 'spec_helper'

describe ForecastParser do

  it "should extract the wind speed from a text node and return an integer respresenting kph" do
    parser = ForecastParser.new
    parser.extract_wind_speed("Clear. High 28&amp;deg;C (82&amp;deg;F). Winds 10 kph SSE").should == 10
    parser.extract_wind_speed("Winds 30 MPH West. Thunderstorms. High18&amp;deg;C").should == 48
  end

  it "should extract the wind direction from a text node and return it as a string" do
    parser = ForecastParser.new
    parser.extract_wind_direction("Clear. High 28&amp;deg;C (82&amp;deg;F). Winds 10 kph SSE").should == "SSE"
    parser.extract_wind_direction("Winds 30 MPH West. Thunderstorms. High18&amp;deg;C").should == "West"
    parser.extract_wind_direction("Mostly cloudy. Winds 22 kph North. Sometimes Thunderstorms. High18&amp;deg;C").should == "North"
  end

end
