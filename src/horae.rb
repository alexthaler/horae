require_relative 'service/metra_scrape_service'

results = Horae::MetraScrapeService.get_live_results({:line => "UP-N", :origin => "RAVENSWOOD", :dest => "CLYBOURN"})
results = Horae::MetraScrapeService.get_live_results({:line => "UP-N", :origin => "OTC", :dest => "RAVENSWOOD"})

results.each do |result|
    puts result
end


# require 'watir-webdriver'
# require './src/model/live_result.rb'

# b = Watir::Browser.new
# b.goto 'http://metrarail.com/metra/wap/en/home/RailTimeTracker.html'
# line_select = b.select_list(:id => 'findLine-0')
# schedule_start = b.select_list(:id => 'schedule-start')
# schedule_end = b.select_list(:id => 'schedule-end')
# submit_button = b.img(:xpath => '//*[(@id = "schedule-group")]//img')
# edit_stations_button = b.a(:xpath => '//*[(@id = "schedule-group")]//*[contains(concat( " ", @class, " " ), concat( " ", "right", " " ))]')

# line_select.options.each do |option|

    # if !option.text.include? "Select"
        # puts option.text
        

        # schedule_start.options.each do |option|
        #     if !option.text.include? "Select" then
        #         departing_station = option.text
        #         schedule_start.select(option.text)

        #         schedule_end.options.each do |option|

        #             if !option.text.include? "Select" and !option.text.include? departing_station then
        #                 schedule_end.select(option.text)
        #                 submit_button.click
        #                 sleep(1)
        #                  edit_stations_button.click
        #             end
        #         end 
        #     end
        # end    
    # end
# end

# line_select.select("Union Pacific / North Line")
# sleep(1)

# schedule_start.select("Ravenswood")
# schedule_end.select("Clybourn")

# submit_button.click
# sleep(1)

# result_rows = ['one', 'two', 'three']
# result_columns = [0, 1, 2]

# result_rows.each do |row|
#     if b.tr(:class => row).exists? then
#         table_row = b.tr(:class => row)

#         train_num = table_row.td(:index => result_columns[0]).text unless !table_row.td(:index => result_columns[0]).exists?
#         scheduled_time = table_row.td(:index => result_columns[1]).text unless !table_row.td(:index => result_columns[1]).exists?
#         actual_time = table_row.td(:index => result_columns[2]).text unless !table_row.td(:index => result_columns[2]).exists?

#         result = LiveResult.new(train_num, scheduled_time, actual_time)

#         puts result
#     end
# end

# b.close