require 'rest-client'
require 'json'

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

		def live_result(line, orig, dest, opts={})

		end
	end
end