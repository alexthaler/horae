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

        if opts[:trips].nil? || opts[:time].nil? || opts[:stop_id].nil? then
          raise "InvalidSearchCriteria!"
        end

        parsed_time = @gtfs_parser.parse_time_string(time)
        all_stop_times = stop_times

        ret_stops = all_stop_times.select { |stop| 
          (trips.include? stop[:trip_id]) &&
          (@gtfs_parser.parse_time_string(stop[:arrival_time]) > parsed_time) &&
          (stop[:stop_id].eql? stop_id)
        }

        ret_stops
      end

      # Search through provided list of trips and filter optionally by service_id and route_id
      def search_trips(trips, opts = {})
        service_id = opts[:service_id]
        route_id = opts[:route_id]
        service_id ||= 'S1'

        valid_trips = trips.select { |trip| 
          trip[:service_id].eql? service_id
        }
        trips_with_route = valid_trips.select{ |trip| 
          if !route_id.nil? then 
            trip[:route_id].eql? route_id 
          else 
            true
          end 
        }
        trips_with_route.map {|trip| trip[:trip_id]}
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

        if opts[:raw]
          return raw_routes
        elsif !opts[:id_list].nil?
          return raw_routes.select { |route| 
            opts[:id_list].include? route[:route_id]
          }
        end

        raw_routes.each_with_index do |stop, index|
          ret_routes[index] = stop[:route_id]
        end

        ret_routes
    	end

      def stops_for_route(route_id) 
        stop_ids = stop_ids_for_route(route_id)
        stops({:id_list => stop_ids})
      end

      def stop_ids_for_route(route_id) 
        all_stop_ids = stops({:raw => false})

        trips_for_line = trips.select { |trip|
          trip[:route_id].eql? route_id
        }
        trip_ids_for_line = trips_for_line.map { |trip|
          trip[:trip_id]
        }

        stops_for_trips = []
        stop_times.each do |stop|
          if trip_ids_for_line.include? stop[:trip_id] and !stops_for_trips.include? stop[:stop_id]
            stops_for_trips.push(stop[:stop_id])
          end
        end

        stops_for_trips
      end

    	def stops(opts = {})
        ret_stops = []

        begin
          raw_stops = @gtfs_parser.parse_file(@data_dir + @@stops_file)
        rescue CSV::MalformedCSVError
          raise "InvalidCSV"
        end

        if opts[:raw]
          return raw_stops
        elsif !opts[:id_list].nil?
          return raw_stops.select { |stop| 
            opts[:id_list].include? stop[:stop_id]
          }
        end

        raw_stops.each_with_index do |stop, index|
          ret_stops.push(stop[:stop_id])
        end

        ret_stops
      end

    end
end