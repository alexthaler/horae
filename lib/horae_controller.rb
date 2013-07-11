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
		delete_keys = [:zone_id, :stop_url, :stop_lon, :stop_lat, :stop_desc]

		live_data = $metra_live_service.stops(params[:route_id])
		schedule_data = $metra_schedule_service.stops_for_route(params[:route_id])

		live_data.each do |key, value| 
			schedule_data.each do |sched_data|
				puts "sched data #{sched_data}"

				delete_keys.each do |del_key|
					sched_data.delete del_key
				end

				puts "--------"
				puts "sched data after #{sched_data}"

				if sched_data[:stop_id] == value['id']
					sched_data[:stop_index] = key.to_i
				end
			end
		end

		schedule_data.to_json
	end

	get '/live/:line/:origin/:dest' do 
		result = $metra_live_service.live_status(params[:line], params[:origin], params[:dest]).to_json
	end

end