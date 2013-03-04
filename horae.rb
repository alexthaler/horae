require 'watir-webdriver'
b = Watir::Browser.new
b.goto 'http://metrarail.com/metra/wap/en/home/RailTimeTracker.html'
line_select = b.select_list(:id => 'findLine-0')
schedule_start = b.select_list(:id => 'schedule-start')
schedule_end = b.select_list(:id => 'schedule-end')
submit_button = b.img(:xpath => '//*[(@id = "schedule-group")]//img')
edit_stations_button = b.a(:xpath => '//*[(@id = "schedule-group")]//*[contains(concat( " ", @class, " " ), concat( " ", "right", " " ))]')

line_select.options.each do |option|

    if !option.text.include? "Select"
        puts option.text
        line_select.select(option.text)

        sleep(1)

        schedule_start.options.each do |option|
            if !option.text.include? "Select" then
                departing_station = option.text
                schedule_start.select(option.text)

                schedule_end.options.each do |option|

                    if !option.text.include? "Select" and !option.text.include? departing_station then
                        schedule_end.select(option.text)
                        submit_button.click
                        sleep(1)
                         edit_stations_button.click
                    end
                end 
            end
        end    
    end
end
b.close