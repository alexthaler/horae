require 'rspec'
require 'metra_schedule_service'

describe "Metra schedule service" do

  before(:each) do
    @service = Horae::MetraScheduleService.new
  end

  it 'should return only the stop ids by default' do
    stop_ids = @service.stops
    stop_ids.length.should equal 239
    stop_ids[0].should eql 'GENEVA'
    stop_ids[238].should eql '35TH'
  end
end