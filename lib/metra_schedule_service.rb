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

      def search_schedule(origin, dest, opts = {})
        service_id

        trip_ids = trip_ids_for_service(trips, service)

        stop_times_for_origin = stop_times.select{ |stop|
          (stop[:stop_id].eql? origin)
        }

        trip_ids_for_st = []
        stop_times_for_origin.each do |time|
          trip_ids_for_st.push(time[:trip_id])
        end

        trip_ids_that_hit_orig_and_dest = []
        trip_ids_for_st.each do |trip_id|
          stops = stop_times.select { |time|
            time[:trip_id] = trip_id
          }
          trip_ids_that_hit_orig_and_dest.push(trip_id) unless !stops.map{|stop| stop[:stop_id]}.includes? (dest)
        end

      end

      def search_stop_times(stop_times, opts = {})
        trips = opts[:trips]
        time = opts[:time]
        stop_id = opts[:stop_id]

        raise "InvalidParameters" unless !opts[:trips].nil? && !opts[:time].nil? && !opts[:stop_id].nil?

      end

      # Search through provided list of trips and filter optionally by service_id and route_id
      def search_trips(trips, opts = {})
        service_id = opts[:service_id]
        route_id = opts[:route_id]
        service_id ||= 'S1'

        valid_trips = trips.select { |trip| 
          trip[:service_id].eql? service_id
        }.select{ |trip| 
          if !route_id.nil? then 
            trip[:route_id].eql? route_id 
          else 
            true
          end 
        }
        valid_trips.map {|trip| trip[:trip_id]}
      end


      ################################################################
      ## FYI - The methods below are basically just glorified getters from the
      ################################################################
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