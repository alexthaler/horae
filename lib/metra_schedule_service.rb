require 'csv'
require_relative 'gtfs_parser'

module Horae 
    class MetraScheduleService 

      @@routes_file = 'routes.txt'
      @@stops_file = 'stops.txt'
      @@trips_file = 'trips.txt'
      @@stop_times_file = 'stop_times.txt'

      @gtfs_parser = nil

    	def initialize(opts = {})
    		@gtfs_parser = GtfsParser.new()
        @data_dir = opts[:data_dir] unless opts[:data_dir].nil?
        @data_dir ||= './data/'
      end

      def search_schedule(origin, dest, service='S1', opts = {})
        trip_ids = trip_ids_for_service(trips, service)

        stop_times_for_origin_dest = stop_times.select{ |stop|
          (stop[:stop_id].eql? origin)|| (stop[:stop_id].eql? dest)
        }
      end

      def trip_ids_for_service(trips, service_id = "S1")
        valid_trips = trips.select { |trip| trip[:service_id].eql? service_id }
        valid_trips.map {|trip| trip[:trip_id]}
      end

      ## FYI - The methods below are basically just glorified getters from the
      def trips(opts = {})
        begin
          ret_stops = @gtfs_parser.parse_file(@data_dir + @@trips_file)
        rescue CSV::MalformedCSVError
          raise "InvalidCSV"
        end

        ret_stops
      end

      def stop_times(opts = {})
        begin
          ret_stop_times = @gtfs_parser.parse_file(@data_dir + @@stop_times_file)
        rescue CSV::MalformedCSVError
          raise "InvalidCSV"
        end

        ret_stop_times
      end

    	def routes(opts = {})
    		ret_routes = []

        begin
          raw_routes = @gtfs_parser.parse_file(@data_dir + @@routes_file)
        rescue CSV::MalformedCSVError
          raise "InvalidCSV"
        end

        return raw_routes unless !opts[:raw]

        raw_routes.each_with_index do |stop, index|
          ret_routes[index] = stop[:route_id]
        end

        ret_routes
    	end

    	def stops(opts = {})
        ret_stops = []

        begin
          raw_stops = @gtfs_parser.parse_file(@data_dir + @@stops_file)
        rescue CSV::MalformedCSVError
          raise "InvalidCSV"
        end

        return raw_stops unless !opts[:raw]

        raw_stops.each_with_index do |stop, index|
          ret_stops[index] = stop[:stop_id]
        end

        ret_stops
      end

    end
end