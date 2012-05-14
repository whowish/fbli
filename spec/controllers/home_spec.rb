# encoding: utf-8
require 'spec_helper'

describe HomeController do
  
  it "shows correct default location" do
    get :index
    
    assigns[:last_location].should be_nil
  end


  it "shows cookied location" do
    
    request.cookies['latitude'] = 13.723377
    request.cookies['longitude'] = 100.476151

    get :index
    
    assigns[:last_location][0].should == 13.723377
    assigns[:last_location][1].should == 100.476151
  end
end