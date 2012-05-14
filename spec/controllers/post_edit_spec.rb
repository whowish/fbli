# encoding: utf-8
require 'spec_helper'

describe PostController do
  
  before(:each) do

    @member = FacebookMember.create(:facebook_id=>"12345",:name=>"TestMember")
    @member2 = FacebookMember.create(:facebook_id=>"1234",:name=>"TestMember")
    
    @post = Post.create(:location=> [30.00, 100.00],
                        :image => "",
                        :message => "msg",
                        :place => "place",
                        :water_height => 100,
                        :member_id => @member.id
                        )
    
    commit_database
  end
  
  
  it "edits post" do

    post :edit, {   :id => @post.id,
                    :message => "msg1",
                    :water_height => "60",
                    :place => "Some place2",
                  }, mock_member_session(@member)
                  
    body = expect_json_response
    body.should be_ok
    commit_database
    
    posts = Post.all
    posts.length.should == 1
    
    posts[0].message.should == "msg1"
    posts[0].place.should == "Some place2"
    posts[0].water_height.should == 60
    
    posts[0].location[0].should == 30
    posts[0].location[1].should == 100
    
    posts[0].member_id.should == @member.id
    
    groups = PostGroup.all
    groups.length.should == 1
    
    groups[0].location[0].should == PostGroup.sanitize_location_unit(posts[0].location[0])
    groups[0].location[1].should == PostGroup.sanitize_location_unit(posts[0].location[1])
    groups[0].water_height.should == 60
    
  end
  
  
  it "does not allow someone else to edit" do

    post :edit, {   :id => @post.id,
                    :message => "msg1",
                    :water_height => "60",
                    :place => "Some place2",
                  }, mock_member_session(@member2)
                  
    body = expect_json_response
    body.should_not be_ok
    
  end
  
  
end
  