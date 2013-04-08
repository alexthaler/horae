require 'sinatra'
require 'json'
require_relative '../service/metra_schedule_service.rb'
require_relative '../service/metra_scrape_service.rb'


class HoraeController < Sinatra::Base

	configure do 
		$metra_schedule_service = Horae::MetraScheduleService.new()
		$metra_scrape_service = Horae::MetraScrapeService.new()
	end

	get '/stops' do 
		$metra_schedule_service.stops().to_json
	end

	get '/routes' do 
		$metra_schedule_service.routes().to_json
	end

	get '/time/:line/:origin/:dest' do 
		$metra_scrape_service.get_live_results(
			{:line => params[:line], :origin => params[:origin], :dest => params[:dest]}).to_json
	end

end