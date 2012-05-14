# encoding: utf-8
require 'spec_helper'


describe PostController do
  
  include PostControllerRspecHelper
  
  before(:each) do

    @member = FacebookMember.create(:facebook_id=>"12345",:name=>"TestMember")
    
    mock_post(30.0006, 100.0000, 100, @member)
    sleep(1)
    
    mock_post(30.0000, 100.0000, 100, @member)
    sleep(1)
    
    mock_post(30.0004, 100.0004, 100, @member)
    sleep(1)
    
    mock_post(30.0004, 100.0000, 0, @member)
    sleep(1)

    mock_post(29.9999, 100.0000, 100, @member)
 
    commit_database
    
  end
  
  
  it "return 304" do
    
    group = PostGroup.first(:conditions=>{:location=>[30.0,100.0]})
    get :view, {:id=>group.id}
  
    etag = response.headers['ETag']
    request.env["HTTP_IF_NONE_MATCH"] = etag
    get :view, {:id=>group.id}
    
    response.status.to_i.should == 304
    
    assigns(:cache_testing).should == "match"
    
  end
  
  
  it "hits but not 304 because users are different" do
    
    group = PostGroup.first(:conditions=>{:location=>[30.0,100.0]})
    get :view, {:id=>group.id}
  
    etag = response.headers['ETag']
    request.env["HTTP_IF_NONE_MATCH"] = etag
    get :view, {:id=>group.id}, mock_member_session(@member)
    
    assigns(:cache_testing).should == "hit"
    
  end
  
  
  it "hits" do
    
    group = PostGroup.first(:conditions=>{:location=>[30.0,100.0]})
    get :view, {:id=>group.id}
  
    get :view, {:id=>group.id}
    
    assigns(:cache_testing).should == "hit"
    
  end
  
  
  it "hits even users are different" do
    
    group = PostGroup.first(:conditions=>{:location=>[30.0,100.0]})
    get :view, {:id=>group.id}
  
    get :view, {:id=>group.id}, mock_member_session(@member)
    
    assigns(:cache_testing).should == "hit"
    
  end
  
  
  it "misses" do
    
    group = PostGroup.first(:conditions=>{:location=>[30.0,100.0]})
    get :view, {:id=>group.id}
  
    group = PostGroup.first(:conditions=>{:location=>[29.9995,100.0]})
    get :view, {:id=>group.id}
    
    assigns(:cache_testing).should == "miss"
    
  end
   
end