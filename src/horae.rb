require_relative 'service/metra_scrape_service'
require_relative 'service/metra_schedule_service'

def print_results(results)
    results.each do |result|
        puts result
    end
end

schedule_service = Horae::MetraScheduleService.new('data/metra_20130308_0424.zip')

routes = schedule_service.routes

puts routes.to_s

# results = Horae::MetraScrapeService.get_live_results({:line => "UP-N", :origin => "RAVENSWOOD", :dest => "CLYBOURN"})
# print_results(results)
# results = Horae::MetraScrapeService.get_live_results({:line => "UP-N", :origin => "OTC", :dest => "RAVENSWOOD"})
# print_results(results)