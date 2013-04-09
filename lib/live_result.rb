class LiveResult 
    attr_accessor :train_num, :scheduled_time, :actual_time

    def initialize(train_num, scheduled_time, actual_time)
        @train_num = train_num
        @scheduled_time = scheduled_time
        @actual_time = actual_time
    end

    def to_s
        return "#{train_num}, #{scheduled_time}, #{actual_time}"
    end
end