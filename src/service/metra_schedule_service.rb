require 'csv'
require_relative '../gtfs/gtfs_parser.rb'

module Horae 
    class MetraScheduleService 

    	def initialize()
    		@gtfs_parser = GtfsParser.new()
    	end

    	def routes(opts = {})
    		@gtfs_parser.parse_file('./data/routes.txt')
    	end

    	def stops(opts = {})
    		@gtfs_parser.parse_file('./data/stops.txt')
    	end

    end
end