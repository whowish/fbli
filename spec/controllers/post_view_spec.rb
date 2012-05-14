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
  
  
  it "views correctly with id" do
    
    group = PostGroup.first(:conditions=>{:location=>[30.0,100.0]})
    get :view, {:id=>group.id}
    assigns(:posts).length.should == 3

    group = PostGroup.first(:conditions=>{:location=>[29.9995,100.0]})
    get :view, {:id=>group.id}
    assigns(:posts).length.should == 1
   
    group = PostGroup.first(:conditions=>{:location=>[30.0005,100.0]})
    get :view, {:id=>group.id}
    assigns(:posts).length.should == 1

  end
  
  
  it "views correctly with lat,lng" do
    
    get :view, {:lat=>30.0000,
                :lng=>100.0000
                }

    assigns(:posts).length.should == 3

    get :view, {:lat=>29.9995,
                :lng=>100.0000
                }

    assigns(:posts).length.should == 1
    
    get :view, {:lat=>30.0005,
                :lng=>100.0000
                }

    assigns(:posts).length.should == 1
    

  end
   
end