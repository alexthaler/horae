require 'sinatra'
require 'json'
require_relative 'metra_schedule_service.rb'
require_relative 'metra_live_service.rb'


class HoraeController < Sinatra::Base

	configure do 
		$metra_schedule_service = Horae::MetraScheduleService.new()
		$metra_live_service = Horae::MetraLiveService.new()
	end

	get '/stops' do 
		$metra_schedule_service.stops().to_json
	end

	get '/stops/:line' do 
		$metra_live_service.stops(params[:line]).to_json
	end

	get '/routes' do 
		$metra_schedule_service.routes().to_json
	end

	get '/routes/:route_id' do
		$metra_schedule_service.routes(:id_list => [params[:route_id]]).to_json
	end

	get '/routes/:route_id/stops' do
		$metra_schedule_service.stops_for_route(params[:route_id]).to_json
	end

	get '/live/:line/:origin/:dest' do 
		result = $metra_scrape_service.get_live_results(
			{:line => params[:line], :origin => params[:origin], :dest => params[:dest]}).to_json
	end

end