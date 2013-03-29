require 'watir-webdriver'
require_relative '../model/live_result.rb'

module Horae
    class MetraScrapeService
        def self.get_live_results(opts = {})
            results = scrape_site(opts[:line], opts[:origin], opts[:dest])
        end

        def self.scrape_site(line, origin, destination)
            b = Watir::Browser.new
            b.goto 'http://metrarail.com/metra/wap/en/home/RailTimeTracker.html'
            line_select = b.select_list(:id => 'findLine-0')
            schedule_start = b.select_list(:id => 'schedule-start')
            schedule_end = b.select_list(:id => 'schedule-end')
            submit_button = b.img(:xpath => '//*[(@id = "schedule-group")]//img')
            edit_stations_button = b.a(:xpath => '//*[(@id = "schedule-group")]//*[contains(concat( " ", @class, " " ), concat( " ", "right", " " ))]')

            line_select.select_value(line)
            sleep(1)

            schedule_start.select_value(origin)
            schedule_end.select_value(destination)

            submit_button.click
            sleep(1)

            results = []
            result_rows = ['one', 'two', 'three']
            result_columns = [0, 1, 2]

            result_rows.each do |row|
                if b.tr(:class => row).exists? then
                    table_row = b.tr(:class => row)

                    train_num = table_row.td(:index => result_columns[0]).text unless !table_row.td(:index => result_columns[0]).exists?
                    scheduled_time = table_row.td(:index => result_columns[1]).text unless !table_row.td(:index => result_columns[1]).exists?
                    actual_time = table_row.td(:index => result_columns[2]).text unless !table_row.td(:index => result_columns[2]).exists?

                    results.push(LiveResult.new(train_num, scheduled_time, actual_time))
                end
            end

            b.close
            return results
        end
    end
end