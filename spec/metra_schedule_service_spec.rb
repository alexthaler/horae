require 'rspec'
require 'metra_schedule_service'

describe "Metra schedule service" do

  before(:each) do
    @service = Horae::MetraScheduleService.new
  end

  it 'routes - should return only the route ids by default' do
    route_ids = @service.routes
    route_ids.length.should eql 11
    route_ids[0].should eql 'BNSF'
    route_ids[10].should eql 'UP-W'
  end

  it 'routes - should return the raw data when raw opt is passed as true' do
    route_ids = @service.routes(:raw => true)
    route_ids.length.should eql 11
    route_ids[0][:route_id].should eql 'BNSF'
    route_ids[0].size.should be > 1
    route_ids[10][:route_id].should eql 'UP-W'
    route_ids[10].size.should be > 1
  end

  it 'routes - should raise parsing error when source file is not valid' do
    service = Horae::MetraScheduleService.new({:data_dir => './fail_data/'})
    lambda {service.routes}.should raise_error
  end

  it 'stops - should return only the stop ids by default' do
    stop_ids = @service.stops
    stop_ids.length.should eql 239
    stop_ids[0].should eql 'GENEVA'
    stop_ids[238].should eql '35TH'
  end

  it 'stops - should return the entire object when raw opt is passed as true' do
    stops = @service.stops({:raw => true})
    stops.length.should eql 239
    stops[0][:stop_id].should eql 'GENEVA'
    stops[238][:stop_id].should eql '35TH'
  end

  it 'stops - should raise parsing error when source file is not valid' do
    service = Horae::MetraScheduleService.new({:data_dir => './fail_data/'})
    lambda {service.stops}.should raise_error
  end

  it 'trips - should return the entire object by default' do
    trips = @service.trips
    trips.length.should eql 1166
  end

  it 'trips - should raise parsing error when source file is not valid' do
    service = Horae::MetraScheduleService.new({:data_dir => './fail_data/'})
    lambda {service.trips}.should raise_error
  end

  it 'stop_times - should return the entire object by default' do
    trips = @service.stop_times
    trips.length.should eql 20373
  end

  it 'stop_times - should raise parsing error when source file is not valid' do
    service = Horae::MetraScheduleService.new({:data_dir => './fail_data/'})
    lambda {service.stop_times}.should raise_error
  end
end