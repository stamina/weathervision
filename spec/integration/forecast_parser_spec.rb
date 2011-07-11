require 'spec_helper'

module Weathervision
  describe ForecastParser do
    let(:test_options_image) { { "fc_query" => "Utrecht", "c_query" => "IUTRECHT23", "mode" => "image", "radar_url" => "http://www.knmi.nl/neerslagradar/images/meest_recente_radarloop451.gif"} }
    let(:test_options_text) { { "fc_query" => "Utrecht", "c_query" => "IUTRECHT37", "mode" => "text", "radar_url" => "http://www.knmi.nl/neerslagradar/images/meest_recente_radarloop451.gif"} }

    it "should parse a weather forecast feed over the internet" do
      doc = Nokogiri::XML(open("http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=Utrecht"))
      doc.class.should == Nokogiri::XML::Document
    end

    it "should parse a weather current feed over the internet" do
      doc = Nokogiri::XML(open("http://api.wunderground.com/weatherstation/WXCurrentObXML.asp?ID=IUTRECHT23"))
      doc.class.should == Nokogiri::XML::Document
    end

    it "should contain useful forecast information" do
      results = {}
      doc = Nokogiri::XML(open("http://api.wunderground.com/auto/wui/geo/ForecastXML/index.xml?query=Utrecht"))
      set = doc.css('simpleforecast forecastday')
      set.each do |node|
        hsh = {}
        hsh['weekday'] = node.css("weekday").text
        hsh['high'] = node.css('high celsius').text
        hsh['low'] = node.css('low celsius').text
        hsh['conditions'] = node.css('conditions').text
        results[node.css('period').text] = hsh
      end
      set = doc.css('txt_forecast')
      results.keys.each do |period|
        forecast_text = set.xpath("//forecastday[period=#{period}]/fcttext").first
        results[period].merge!({ "text" => forecast_text.text}) if !forecast_text.nil?
      end
      set = doc.css('moon_phase')
      node = set.first
      sun = {}
      sun['hour'] = node.css('sunset hour').text
      sun['minute'] = node.css('sunset minute').text
      sun.count.should > 0
      results.count.should > 0
    end

    it "should contain useful current information" do
      doc = Nokogiri::XML(open("http://api.wunderground.com/weatherstation/WXCurrentObXML.asp?ID=IUTRECHT23"))
      set = doc.css('current_observation')
      node = set.first
      current = {}
      current['city'] = node.css('city').text
      current['temp'] = node.css('temp_c').text
      current['updated'] = node.css("observation_time_rfc822").text
      current['windspeed'] = node.css('wind_mph').text
      current['winddir'] = node.css('wind_dir').text
      current['winddegrees'] = node.css('wind_degrees').text
      current['humidity'] = node.css('relative_humidity').text
      current.count.should > 0
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
      parser.forecast_doc = mock(Nokogiri::XML).as_null_object
      parser.parse_forecast
    end

    it "should parse the current weather conditions" do
      parser = ForecastParser.new(test_options_image)
      parser.current_doc = mock(Nokogiri::XML).as_null_object
      parser.forecast_doc = mock(Nokogiri::XML).as_null_object
      parser.should_receive(:extract_wind_speed)
      parser.should_receive(:extract_wind_direction)
      parser.parse_current
      parser.current.keys.size.should == 8
    end

  end
end
