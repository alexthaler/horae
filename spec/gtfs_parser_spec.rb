require 'gtfs_parser'

describe 'GTFSParser' do

  it "returns the number of stops in the file minus one" do
    parser = Horae::GtfsParser.new
    parsed_stops = parser.parse_file('spec_data/test_stops.txt')
    parsed_stops.length.should eql 2
  end

  it "returns correctly parsed stop ids" do
    parser = Horae::GtfsParser.new
    parsed_stops = parser.parse_file('spec_data/test_stops.txt')

    parsed_stops[0][:stop_id].should eql 'GENEVA'
    parsed_stops[1][:stop_id].should eql 'WCHICAGO'
  end

end