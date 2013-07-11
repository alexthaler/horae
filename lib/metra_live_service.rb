require 'rest-client'
require 'json'
require 'time'

module Horae
	class MetraLiveService

		def initialize()
		end

		def stops(line, opts={})
			stops_url = 'http://metrarail.com/content/metra/en/home/jcr:content/trainTracker.get_stations_from_line.json?trackerNumber=0&trainLineId='
			json_string = RestClient.get(stops_url + line)
			result = JSON.parse(json_string)
			result['stations']
		end

		def live_status(line, orig, dest, opts={})
			live_status_url = 'http://12.205.200.243/AJAXTrainTracker.svc/GetAcquityTrainData'
			request = build_request(line, orig, dest)
			headers = {'Content-Type' => 'application/json; charset=UTF-8'}

			RestClient.options(live_status_url)
			response = RestClient.post(live_status_url, request.to_json, headers)
			return convert_response(response.body)
		end

		def build_request(line, orig, dest)
			station_request = {}
			station_request['Corridor'] = line
			station_request['Origin'] = orig
			station_request['Destination'] = dest
			station_request['timestamp'] = "/Date(#{Time.now.to_i})/"

			request = {'stationRequest' => station_request}
			request
		end

		def convert_response(body) 
			date_strings = ['scheduled_dpt_time', 'estimated_dpt_time', 'timestamp']
			train_strings = ['train1', 'train2', 'train3']
			response = []

			clean_body = JSON.parse(body)['d']
			clean_model = JSON.parse(clean_body)

			train_strings.each do |train_string|
				response.push(clean_model[train_string])
			end

			response.each do |train|
				puts "train num is #{train['train_num']}"
				if train['train_num'] == '0000'
					response.delete(train)
					break
				end
				
				date_strings.each do |string|
					train[string] = convert_date_time(train[string])
				end

				estimated_depart = Time.parse(train['estimated_dpt_time'])
				train['eta_min'] = ((Time.now - estimated_depart)/60).floor.abs
			end

			puts "resp - #{response}"
			response
		end

		def convert_date_time(str) 
			first_half = str[0, str.index(')')]
			parse_string = first_half[first_half.index('(')+1, first_half.length]

			Time.at(parse_string[0, parse_string.length-3].to_i).iso8601
		end
	end
end