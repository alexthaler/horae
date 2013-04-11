require 'rspec'
require 'metra_schedule_service'

describe "Metra schedule service" do

  before(:each) do
    @service = Horae::MetraScheduleService.new

    $fake_trips = [
      {:trip_id => 'UPN_V1-1', :service_id => 'S1', :route_id => 'UP-N'},
      {:trip_id => 'BNSF_V1-1', :service_id => 'S1', :route_id => 'BNSF'}, 
      {:trip_id => 'UPN_v2-1', :service_id => 'S2', :route_id => 'UP-N'},
      {:trip_id => 'BNSF_V3-1', :service_id => 'S3', :route_id => 'BNSF'}
    ]

    $fake_stop_times = [
      {:trip_id => 'UPN_V1-1', :arrival_time => '04:30:00', :stop_id => 'OTC'},
      {:trip_id => 'UPN_V1-2', :arrival_time => '10:30:00', :stop_id => 'OTC'},
      {:trip_id => 'UPN_V1-3', :arrival_time => '22:30:00', :stop_id => 'OTC'},
      {:trip_id => 'UPN_V1-1', :arrival_time => '05:00:00', :stop_id => 'CLYBOURN'},
      {:trip_id => 'UPN_V1-1', :arrival_time => '05:30:00', :stop_id => 'RAVENSWOOD'},
      {:trip_id => 'UPW_V1-1', :arrival_time => '22:30:00', :stop_id => 'OTC'},
      {:trip_id => 'BNSF_V1-1', :arrival_time => '05:30:00', :stop_id => 'CUS'},
      {:trip_id => 'BNSF_V1-1', :arrival_time => '06:30:00', :stop_id => 'BERWYN'},
    ]
  end

  #####################################################################################
  ## search_stop_times tests
  #####################################################################################

  it 'should raise an error when calling search_stop_times with no opts' do
    lambda {@service.search_stop_times($fake_stop_times)}.should raise_error
  end

  it 'should raise an error when calling search_stop_times with only trip_ids' do
    trip_ids = ['UPN_V1-1']
    lambda {@service.search_stop_times($fake_stop_times, {:trips => trip_ids})}
      .should raise_error
  end

  it 'should raise an error when calling search_stop_times with only trip_ids and arrival_time' do
    trip_ids = ['UPN_V1-1']
    lambda {@service.search_stop_times($fake_stop_times, {:trips => trip_ids, :time => '01:30:00'})}
      .should raise_error
  end

  it 'should raise an error when calling search_stop_times with arrival_time and stop' do
    lambda {@service.search_stop_times($fake_stop_times, {:time => '01:30:00', :stop => 'RAVENSWOOD'})}
      .should raise_error
  end

  it 'should filter stop times based on the parameters passed in - multiple stops for trip_id and late time' do
    trip_ids = ['UPN_V1-1']
    time = '12:00:00'
    stop = 'OTC'
    results = @service.search_stop_times($fake_stop_times, 
      {:trips => trip_ids, :time => time, :stop => stop})

    results.size.should eql 0
  end

  it 'should filter stop times based on the parameters passed in - multiple stops for trip_id, valid time and invalid stop' do
    trip_ids = ['UPN_V1-1']
    time = '03:00:00'
    stop = 'NOTFOUND'
    results = @service.search_stop_times($fake_stop_times, 
      {:trips => trip_ids, :time => time, :stop => stop})

    results.size.should eql 0
  end

  it 'should filter stop times based on the parameters passed in - multiple stops for trip_id and midnight' do
    trip_ids = ['UPN_V1-1']
    time = '00:00:00'
    stop = 'OTC'
    results = @service.search_stop_times($fake_stop_times, 
      {:trips => trip_ids, :time => time, :stop => stop})

    results.size.should eql 1
    trip_ids.should include results[0][:trip_id]
    results[0][:arrival_time].should eql '04:30:00'
    results[0][:stop_id].should eql stop
  end

  it 'should filter stop times based on the parameters passed in - multiple stops for trip_id and early morning' do
    trip_ids = ['UPN_V1-1']
    time = '03:00:00'
    stop = 'OTC'
    results = @service.search_stop_times($fake_stop_times, 
      {:trips => trip_ids, :time => time, :stop => stop})

    results.size.should eql 1
    trip_ids.should include results[0][:trip_id]
    results[0][:arrival_time].should eql '04:30:00'
    results[0][:stop_id].should eql stop
  end

  it 'should filter stop times based on the parameters passed in - single stops for trip_id and early morning' do
    trip_ids = ['BNSF_V1-1']
    time = '03:00:00'
    stop = 'CUS'
    results = @service.search_stop_times($fake_stop_times, 
      {:trips => trip_ids, :time => time, :stop => stop})

    results.size.should eql 1
    trip_ids.should include results[0][:trip_id]
    results[0][:arrival_time].should eql '05:30:00'
    results[0][:stop_id].should eql stop
  end

  it 'should filter stop times based on the parameters passed in - multiple stops for trip_id and early morning' do
    trip_ids = ['UPW_V1-1']
    time = '03:00:00'
    stop = 'OTC'
    results = @service.search_stop_times($fake_stop_times, 
      {:trips => trip_ids, :time => time, :stop => stop})

    results.size.should eql 1
    trip_ids.should include results[0][:trip_id]
    results[0][:arrival_time].should eql '22:30:00'
    results[0][:stop_id].should eql stop
  end

  it 'should filter stop times based on the parameters passed in - single stop for trip_id and midnight single station result' do
    trip_ids = ['UPN_V1-1']
    time = '00:00:00'
    stop = 'RAVENSWOOD'
    results = @service.search_stop_times($fake_stop_times, 
      {:trips => trip_ids, :time => time, :stop => stop})

    results.size.should eql 1
    trip_ids.should include results[0][:trip_id]
    results[0][:arrival_time].should eql '05:30:00'
    results[0][:stop_id].should eql stop
  end

  it 'should filter stop times based on the parameters passed in - single stop for trip_id and early morning single station result' do
    trip_ids = ['UPN_V1-1']
    time = '03:00:00'
    stop = 'CLYBOURN'
    results = @service.search_stop_times($fake_stop_times, 
      {:trips => trip_ids, :time => time, :stop => stop})

    results.size.should eql 1
    trip_ids.should include results[0][:trip_id]
    results[0][:arrival_time].should eql '05:00:00'
    results[0][:stop_id].should eql stop
  end

  it 'should filter stop times based on the parameters passed in - single stops for multiple trip_ids and early morning' do
    trip_ids = ['UPN_V1-1', 'UPN_V1-2', 'UPN_V1-3']
    time = '03:00:00'
    stop = 'OTC'
    results = @service.search_stop_times($fake_stop_times, 
      {:trips => trip_ids, :time => time, :stop => stop})

    results.size.should eql 3
    results.each do |result|
      trip_ids.should include result[:trip_id]
    end
    results[0][:arrival_time].should eql '04:30:00'
    results[1][:arrival_time].should eql '10:30:00'
    results[2][:arrival_time].should eql '22:30:00'
    result[:stop_id].should eql stop    
  end

  it 'should filter stop times based on the parameters passed in - single stops for multiple trip_ids and early morning' do
    trip_ids = ['UPN_V1-1', 'UPN_V1-2', 'UPN_V1-3']
    time = '08:00:00'
    stop = 'OTC'
    results = @service.search_stop_times($fake_stop_times, 
      {:trips => trip_ids, :time => time, :stop => stop})

    results.size.should eql 3
    results.each do |result|
      trip_ids.should include result[:trip_id]
    end
    results[0][:arrival_time].should eql '10:30:00'
    results[1][:arrival_time].should eql '22:30:00'
    result[:stop_id].should eql stop    
  end

  it 'should filter stop times based on the parameters passed in - single stops for multiple trip_ids and early morning' do
    trip_ids = ['UPN_V1-1', 'UPN_V1-2', 'UPN_V1-3']
    time = '18:00:00'
    stop = 'OTC'
    results = @service.search_stop_times($fake_stop_times, 
      {:trips => trip_ids, :time => time, :stop => stop})

    results.size.should eql 3
    results.each do |result|
      trip_ids.should include result[:trip_id]
    end
    results[0][:arrival_time].should eql '22:30:00'
    result[:stop_id].should eql stop    
  end

  #####################################################################################
  ## search_trips tests
  #####################################################################################

  it 'should default to S1 when searching for trips' do
    result = @service.search_trips($fake_trips)
    result.size.should eql 2
  end

  it 'should filter trips correctly using the parameters passed into search_trips' do
    
    result = @service.search_trips($fake_trips)
    result.size.should eql 2
    result.should include('BNSF_V1-1', 'UPN_V1-1')

    result = @service.search_trips($fake_trips, {:service_id => 'S1'})
    result.size.should eql 2
    result.should include('BNSF_V1-1', 'UPN_V1-1')
    result = @service.search_trips($fake_trips, {:service_id => 'S1', :route_id => 'BNSF'})
    result.size.should eql 1
    result.should include('BNSF_V1-1')
    result = @service.search_trips($fake_trips, {:service_id => 'S1', :route_id => 'UP-N'})
    result.size.should eql 1
    result.should include('UPN_V1-1')
    result = @service.search_trips($fake_trips, {:service_id => 'S1', :route_id => 'NOTFOUND'})
    result.size.should eql 0

    result = @service.search_trips($fake_trips, {:service_id => 'S2'})
    result.size.should eql 1
    result.should include('UPN_v2-1')
    result = @service.search_trips($fake_trips, {:service_id => 'S2', :route_id => 'UP-N'})
    result.size.should eql 1
    result.should include('UPN_v2-1')
    result = @service.search_trips($fake_trips, {:service_id => 'S2', :route_id => 'NOTFOUND'})
    result.size.should eql 0

    result = @service.search_trips($fake_trips, {:service_id => 'S3'})
    result.size.should eql 1
    result.should include('BNSF_V3-1')
    result = @service.search_trips($fake_trips, {:service_id => 'S3', :route_id => 'BNSF'})
    result.size.should eql 1
    result.should include('BNSF_V3-1')
    result = @service.search_trips($fake_trips, {:service_id => 'S3', :route_id => 'NOTFOUND'})
    result.size.should eql 0

    result = @service.search_trips($fake_trips, {:service_id => 'S5'})
    result.size.should eql 0
  end

  #####################################################################################
  ## getters tests
  #####################################################################################

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