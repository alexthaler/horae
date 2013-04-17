require 'watir-webdriver'
require_relative 'live_result'

module Horae
    class MetraScrapeService

        def initialize()
            $watir_instance = Watir::Browser.new
        end

        def get_live_results(opts = {})
            results = scrape_site(opts[:line], opts[:origin], opts[:dest])
        end

        def scrape_site(line, origin, destination)
            $watir_instance.goto 'http://metrarail.com/metra/wap/en/home/RailTimeTracker.html'
            line_select = $watir_instance.select_list(:id => 'findLine-0')
            schedule_start = $watir_instance.select_list(:id => 'schedule-start')
            schedule_end = $watir_instance.select_list(:id => 'schedule-end')
            submit_button = $watir_instance.img(:xpath => '//*[(@id = "schedule-group")]//img')
            edit_stations_button = $watir_instance.a(:xpath => '//*[(@id = "schedule-group")]//*[contains(concat( " ", @class, " " ), concat( " ", "right", " " ))]')

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
                if $watir_instance.tr(:class => row).exists? then
                    table_row = $watir_instance.tr(:class => row)

                    train_num = table_row.td(:index => result_columns[0]).text unless !table_row.td(:index => result_columns[0]).exists?
                    scheduled_time = table_row.td(:index => result_columns[1]).text unless !table_row.td(:index => result_columns[1]).exists?
                    actual_time = table_row.td(:index => result_columns[2]).text unless !table_row.td(:index => result_columns[2]).exists?

                    result = {:train_number => train_num, :scheduled_time => scheduled_time, :actual_time => actual_time}
                    results.push(result)
                end
            end

            return results
        end
    end
end