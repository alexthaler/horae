require 'csv'

module Horae
  class GtfsParser

    def parse_file(path_to_file, opts = {})
      ret_array = []
      data_elements = []
      first_row = true

      CSV.foreach(path_to_file) do |row|
        if first_row then
          row.each_with_index do |title, index|
            data_elements[index] = strip_or_self(title).to_sym
          end
          first_row = false
        else
          raise "InvalidCSV" unless data_elements.length == row.length
          current = {}

          row.each_with_index do |item, index|
            current[data_elements[index]] = strip_or_self(item)
          end

          ret_array.push(current)
        end
      end

      ret_array
    end

    def strip_or_self(string)
      string.strip! || string if string
    end

    def parse_time_string(time_string)
      time_tomorrow = false
      now = Time.new
      time_elements = time_string.split(':')

      if time_elements[0].to_i > 23 then
        time_tomorrow = true
        time_elements[0] = time_elements[0].to_i - 24      
      end

      if time_tomorrow then
        tomorrow_date = Date.today + 1
        Time.new(now.year, now.month, tomorrow_date.mday,
          time_elements[0].to_i, 
          time_elements[1].to_i,
          time_elements[2].to_i)
      else   
        Time.new(now.year, now.month, now.day, 
          time_elements[0].to_i, 
          time_elements[1].to_i, 
          time_elements[2].to_i)
      end

    end

  end
end