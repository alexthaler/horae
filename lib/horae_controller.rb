require 'sinatra'
require 'json'
require_relative 'metra_schedule_service.rb'
require_relative 'metra_live_service.rb'


class HoraeController < Sinatra::Base

	configure do 
		$metra_schedule_service = Horae::MetraScheduleService.new()
		$metra_live_service = Horae::MetraLiveService.new()

        set :public_folder, 'public'
        enable :logging

        # Spit stdout and stderr to a file during production
        # in case something goes wrong
        $stdout.sync = true
	end

	get '/' do
        send_file File.join(settings.public_folder, 'index.html')
	end

	get '/stops' do 
		$metra_schedule_service.stops().to_json
	end

	get '/stops/:line' do 
		$metra_live_service.stops(params[:line]).to_json
	end

	get '/routes' do 
		$metra_schedule_service.routes({:raw => true}).to_json
	end

	get '/routes/:route_id' do
		$metra_schedule_service.routes(:id_list => [params[:route_id]]).to_json
	end

	get '/routes/:route_id/stops' do
		$metra_schedule_service.stops_for_route(params[:route_id]).to_json
	end

	get '/live/:line/:origin/:dest' do 
		result = $metra_live_service.live_status(params[:line], params[:origin], params[:dest]).to_json
	end

end