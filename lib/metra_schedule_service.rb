require 'csv'
require_relative 'gtfs_parser'

module Horae 
    class MetraScheduleService 

    	def initialize()
    		@gtfs_parser = GtfsParser.new()
    	end

    	def routes(opts = {})
    		@gtfs_parser.parse_file('./data/routes.txt')
    	end

      #@return stop_id for each stop in the system
    	def stops(opts = {})
        ret_stops = []
    		raw_stops = @gtfs_parser.parse_file('./data/stops.txt')

        if opts[:raw] then
          return raw_stops
        end

        raw_stops.each_with_index do |stop, index|
          ret_stops[index] = stop['stop_id']
        end

        ret_stops
    	end

    end
end