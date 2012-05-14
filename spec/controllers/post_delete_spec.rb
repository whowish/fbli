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
  
  
  it "deletes post" do

    post :delete, {   :id => @post.id,
                  }, mock_member_session(@member)
                  
    body = expect_json_response
    body.should be_ok
    commit_database
    
    posts = Post.all
    posts.length.should == 0
    
    groups = PostGroup.all
    groups.length.should == 0
    
    @member = FacebookMember.find(@member.id)
    @member.all_score.should == 0
    
    location_group = ScorePerDay.get_location_group([30,100])
    score = ScorePerDay.get(@member.id, Time.now,location_group)
    score.score.should == 0
    
    max = MaxScorePerDayPerArea.get(location_group, Time.now)
    max.score.should == 0
    max.member_id.should == @member.id
    
  end
  
  
  it "does not allow someone else to edit" do

    post :delete, { :id => @post.id,
                  }, mock_member_session(@member2)
                  
    body = expect_json_response
    body.should_not be_ok
    
    posts = Post.all
    posts.length.should == 1
    
    groups = PostGroup.all
    groups.length.should == 1
    
  end
  
  
  it "deletes the latest post and its group changes to the next one" do

    sleep(1)
    FileUtils.copy(File.expand_path("../../assets/taylor_swift.jpg",__FILE__), 
                    File.join(Rails.root, "public/uploads/temp/taylor_swift.jpg"))   

    @post2 = Post.create(:location=> [30.00, 100.00],
                    :image => "/uploads/temp/taylor_swift.jpg",
                    :message => "msg",
                    :place => "place",
                    :water_height => 99,
                    :member_id => @member2.id
                    )

    groups = PostGroup.all
    groups.length.should == 1
    groups[0].water_height.should == 99

    post :delete, {   :id => @post2.id,
                  }, mock_member_session(@member2)

    body = expect_json_response
    body.should be_ok
    commit_database
    
    groups = PostGroup.all
    groups.length.should == 1

    groups = PostGroup.all
    groups.length.should == 1
    groups[0].water_height.should == 100

  end
  
  
  it "deletes and max score is changed to the second place" do
    
    FileUtils.copy(File.expand_path("../../assets/taylor_swift.jpg",__FILE__), 
                    File.join(Rails.root, "public/uploads/temp/taylor_swift.jpg"))   

    @post2 = Post.create(:location=> [30.00, 100.00],
                    :image => "/uploads/temp/taylor_swift.jpg",
                    :message => "msg",
                    :place => "place",
                    :water_height => 100,
                    :member_id => @member2.id
                    )
    
    location_group = ScorePerDay.get_location_group([30,100])
    max = MaxScorePerDayPerArea.get(location_group, Time.now)
    max.score.should == 10
    max.member_id.should == @member2.id
    
    post :delete, {   :id => @post2.id,
                  }, mock_member_session(@member2)
                  
    body = expect_json_response
    body.should be_ok
    commit_database
    
    @member2 = FacebookMember.find(@member2.id)
    @member2.all_score.should == 0
    
    location_group = ScorePerDay.get_location_group([30,100])
    score = ScorePerDay.get(@member2.id, Time.now,location_group)
    score.score.should == 0
    
    max = MaxScorePerDayPerArea.get(location_group, Time.now)
    max.score.should == 1
    max.member_id.should == @member.id
    
  end
  
end
  