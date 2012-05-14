# encoding: utf-8
require 'spec_helper'

describe "TwitterImageUrlResolver" do
  
  
  it "resolves yFrog" do
    
    url = TwitterImageUrlResolver.resolve("http://yfrog.com/h3ebyaxnj")
    url.should == "http://yfrog.com/h3ebyaxnj:iphone"

  end


  it "resolves twitgoo" do
    
    url = TwitterImageUrlResolver.resolve("http://twitgoo.com/4tjybp")
    url.should == "http://twitgoo.com/4tjybp/img"

  end


  it "resolves lockerz" do
    
    url = TwitterImageUrlResolver.resolve("http://lockerz.com/s/153098132")
    url.should == "http://api.plixi.com/api/tpapi.svc/imagefromurl?url=#{CGI.escape('http://lockerz.com/s/153098132')}&size=mobile"
    
  end


end