require 'watir-webdriver'
require 'model/live_result'

b = Watir::Browser.new
b.goto 'http://metrarail.com/metra/wap/en/home/RailTimeTracker.html'
line_select = b.select_list(:id => 'findLine-0')
schedule_start = b.select_list(:id => 'schedule-start')
schedule_end = b.select_list(:id => 'schedule-end')
submit_button = b.img(:xpath => '//*[(@id = "schedule-group")]//img')
edit_stations_button = b.a(:xpath => '//*[(@id = "schedule-group")]//*[contains(concat( " ", @class, " " ), concat( " ", "right", " " ))]')

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

line_select.select("Union Pacific / North Line")
sleep(1)

schedule_start.select("Ravenswood")
schedule_end.select("Clybourn")

submit_button.click
sleep(1)

result_rows = ['one', 'two', 'three']
result_columns = [0, 1, 2]

result_rows.each do |row|
    if b.tr(:class => row).exists? then
        table_row = b.tr(:class => row)

        train_num = table_row.td(:index => result_columns[0]).text unless !table_row.td(:index => result_columns[0]).exists?
        scheduled_time = table_row.td(:index => result_columns[1]).text unless !table_row.td(:index => result_columns[1]).exists?
        actual_time = table_row.td(:index => result_columns[2]).text unless !table_row.td(:index => result_columns[2]).exists?

        result = 
        # result_columns.each do |column|
        #     if b.tr(:class => row).td(:index => column).exists? then
        #         puts b.tr(:class => row).td(:index => column).text
        #     end
        # end
    end
end

b.close