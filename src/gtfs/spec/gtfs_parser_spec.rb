require 'gtfs_parser'

describe 'GtfsParser' do 

    it "correctly parses stops" do 
        parser = Horae::GtfsParser.new;
        parsed_stops = parser.parse_file('../data/test_stops.txt')
        parsed_stops.length.should eql 2
    end

end