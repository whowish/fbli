# encoding: utf-8
require 'spec_helper'


describe PostController do
  
  include PostControllerRspecHelper
  
  before(:each) do

    @member = FacebookMember.create(:facebook_id=>"12345",:name=>"TestMember")
    
    mock_post(30.0005, 100.0000, 100, @member)
    sleep(1)
    
    mock_post(30.0000, 100.0000, 99, @member)
    sleep(1)
    
    mock_post(30.0004, 100.0004, 98, @member)
    sleep(1)
    
    mock_post(30.0004, 100.0000, 0, @member)
    sleep(1)

    mock_post(29.9999, 100.0000, 101, @member)
 
    commit_database
    
  end
  
  
  it "queries correctly" do

    post :index, {:ne_lat => 26.9993,
                  :ne_lng => 96,
                  :sw_lat => 35.0006,
                  :sw_lng => 103.0006,
                  :limit => 2
                  }
                  
    body = expect_json_response
    body.should be_ok
    
    body['results'].length.should == 2
    
    puts body['results'][0]['location'][0]
    puts body['results'][1]['location'][0]
    
    body['results'][0]['location'][0].should == 29.9995
    body['results'][0]['location'][1].should == 100.0000
    body['results'][0]['water_height'].should == 101
    
    body['results'][1]['location'][0].should == 30.0005
    body['results'][1]['location'][1].should == 100.0000
    body['results'][1]['water_height'].should == 100
    
  end
  
  
  it "queries correctly" do

    post :index, {:ne_lat => 26,
                  :ne_lng => 96,
                  :sw_lat => 35.0004,
                  :sw_lng => 105.0004,
                  :limit => 3
                  }
                  
    body = expect_json_response
    body.should be_ok
    
    body['results'].length.should == 3
    
    body['results'][0]['location'][0].should == 29.9995
    body['results'][0]['location'][1].should == 100.0000
    body['results'][0]['water_height'].should == 101
    
    body['results'][1]['location'][0].should == 30.0005
    body['results'][1]['location'][1].should == 100.0000
    body['results'][1]['water_height'].should == 100
    
    body['results'][2]['location'][0].should == 30.0000
    body['results'][2]['location'][1].should == 100.0000
    body['results'][2]['water_height'].should == 0
    
    
    
  end
  
  
end