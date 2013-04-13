require 'gtfs_parser'
require 'date'

describe 'GTFSParser' do

  before(:each) do
    $parser = Horae::GtfsParser.new
  end

  it 'should correctly parse time_string, midnight' do
    now = Time.new
    time_string = '00:00:00'

    t = $parser.parse_time_string(time_string)

    t.year.should eql now.year
    t.month.should eql now.month
    t.day.should eql now.day
    t.hour.should eql 0
    t.min.should eql 0
    t.sec.should eql 0
  end

  it 'should correctly parse time_string, midnight' do
    now = Time.new
    time_string = '06:11:22'

    t = $parser.parse_time_string(time_string)

    t.year.should eql now.year
    t.month.should eql now.month
    t.day.should eql now.day
    t.hour.should eql 6
    t.min.should eql 11
    t.sec.should eql 22
  end

  it 'should correctly parse time_string, 12th hour' do
    now = Time.new
    time_string = '12:34:56'

    t = $parser.parse_time_string(time_string)

    t.year.should eql now.year
    t.month.should eql now.month
    t.day.should eql now.day
    t.hour.should eql 12
    t.min.should eql 34
    t.sec.should eql 56
  end

  it 'should correctly parse time_string, 1 second away from midnight' do
    now = Time.new
    time_string = '23:59:59'

    t = $parser.parse_time_string(time_string)

    t.year.should eql now.year
    t.month.should eql now.month
    t.day.should eql now.day
    t.hour.should eql 23
    t.min.should eql 59
    t.sec.should eql 59
  end

  it 'should correctly parse time_string, 24th hour' do
    now = Time.new
    tomorrow = Date.today+1
    time_string = '24:25:00'

    t = $parser.parse_time_string(time_string)

    t.year.should eql now.year
    t.month.should eql now.month
    t.day.should eql tomorrow.mday 
    t.hour.should eql 00
    t.min.should eql 25
    t.sec.should eql 00
  end

  it 'should correctly parse time_string, 25th hour' do
    now = Time.new
    tomorrow = Date.today+1
    time_string = '25:50:00'

    t = $parser.parse_time_string(time_string)

    t.year.should eql now.year
    t.month.should eql now.month
    t.day.should eql tomorrow.mday 
    t.hour.should eql 1
    t.min.should eql 50
    t.sec.should eql 00
  end

  it "returns the number of stops in the file minus one" do
    parsed_stops = $parser.parse_file('spec_data/test_stops.txt')
    parsed_stops.length.should eql 2
  end

  it "returns correctly parsed stop ids" do
    parsed_stops = $parser.parse_file('spec_data/test_stops.txt')

    #This test should always verify more than the first field in the file to ensure the removal of 
    #extra padding before and after the string variables.
    parsed_stops[0][:stop_id].should eql 'GENEVA'
    parsed_stops[0][:stop_name].should eql 'Geneva'
    parsed_stops[0][:stop_desc].should eql ''
    parsed_stops[0][:stop_lat].should eql '41.8816667'
    parsed_stops[1][:stop_id].should eql 'WCHICAGO'
  end

end