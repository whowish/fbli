# encoding: utf-8
require 'spec_helper'

describe PostController do
  
  before(:each) do
    
    FileUtils.mkdir_p File.join(Rails.root, "public/uploads/temp")
    FileUtils.mkdir_p File.join(Rails.root, "public/uploads/images")
    
    Dir[File.join(Rails.root, "public/uploads/temp/*")].each { |f| 
      FileUtils.remove(f, :force=>true)
    }
    
    Dir[File.join(Rails.root, "public/uploads/images/*")].each { |f| 
      FileUtils.remove(f, :force=>true)
    }
    
    @member = FacebookMember.create(:facebook_id=>"1234",:name=>"TestMember")
    commit_database
  end
  
  it "creates post with image" do

    FileUtils.copy(File.expand_path("../../assets/taylor_swift.jpg",__FILE__), 
                  File.join(Rails.root, "public/uploads/temp/taylor_swift.jpg"))
    
    post :create, { :message => "msg",
                    :image => "/uploads/temp/taylor_swift.jpg",
                    :water_height => "100",
                    :place => "Some place",
                    :lat => "30",
                    :lng => "100"
                  }, mock_member_session(@member)
                  
    body = expect_json_response
    body.should be_ok
    commit_database
    
    groups = PostGroup.all
    groups.length.should == 1
    
    posts = Post.all
    posts.length.should == 1
    
    groups[0].location[0].should == PostGroup.sanitize_location_unit(posts[0].location[0])
    groups[0].location[1].should == PostGroup.sanitize_location_unit(posts[0].location[1])
    groups[0].water_height.should == 100
    
    File.exists?(File.join(Rails.root, "public/uploads/temp/taylor_swift.jpg")).should == false
    
    posts[0].message.should == "msg"
    posts[0].place.should == "Some place"
    posts[0].water_height.should == 100
    
    posts[0].location[0].should == 30
    posts[0].location[1].should == 100
    posts[0].post_group_id.should == groups[0].id
    
    posts[0].member_id.should == @member.id
    
    File.exists?(File.join(Rails.root, "public", posts[0].image)).should == true

    
    @member = FacebookMember.find(@member.id)
    @member.all_score.should == Post::SCORE_UPLOAD_PIC
    
    location_group = ScorePerDay.get_location_group([30,100])
    score = ScorePerDay.get(@member.id, Time.now,location_group)
    score.score.should == Post::SCORE_UPLOAD_PIC
    
  end
  
  
  it "creates post without image" do
    
    post :create, { :message => "msg",
                :image => "",
                :water_height => "100",
                :place => "Some place",
                :lat => "30",
                :lng => "100"
              }, mock_member_session(@member)
                  
    body = expect_json_response
    body.should be_ok
    commit_database
    
    groups = PostGroup.all
    groups.length.should == 1
    
    posts = Post.all
    posts.length.should == 1
    
    groups[0].location[0].should == PostGroup.sanitize_location_unit(posts[0].location[0])
    groups[0].location[1].should == PostGroup.sanitize_location_unit(posts[0].location[1])
    groups[0].water_height.should == 100

    posts[0].message.should == "msg"
    posts[0].place.should == "Some place"
    posts[0].water_height.should == 100
    
    posts[0].location[0].should == 30
    posts[0].location[1].should == 100
    posts[0].post_group_id.should == groups[0].id
    
    posts[0].member_id.should == @member.id
    
    posts[0].image.should == ""

    @member = FacebookMember.find(@member.id)
    @member.all_score.should == Post::SCORE_NOPIC
    
    score = ScorePerDay.get(@member.id, Time.now, ScorePerDay.get_location_group([30,100]))
    score.score.should == Post::SCORE_NOPIC
    
  end
  
  it "creates 2 posts in the same location" do
    
    post :create, { :message => "msg",
                    :image => "",
                    :water_height => "100",
                    :traffic_level => Post::TRAFFIC_RED,
                    :place => "Some place",
                    :lat => "30",
                    :lng => "100"
                  }, mock_member_session(@member)
                  
    groups = PostGroup.all
    groups.length.should == 1
    
    groups[0].water_height.should == 100
    groups[0].traffic_level.should == Post::TRAFFIC_RED
    groups[0].updated_ticket_number.should == 0
    
                  
    post :create, { :message => "msg",
                    :image => "",
                    :water_height => "99",
                    :traffic_level => Post::TRAFFIC_GREEN,
                    :place => "Some place",
                    :lat => "30.0004",
                    :lng => "100.0004"
                  }, mock_member_session(@member)
                  

    groups = PostGroup.all
    groups.length.should == 1
    
    groups[0].water_height.should == 99
    groups[0].traffic_level.should == Post::TRAFFIC_GREEN
    groups[0].updated_ticket_number.should == 1
    
  end
  

  it "creates 2 posts that are grouped, and 1 post is not" do
    
    post :create, { :message => "msg",
                    :image => "",
                    :water_height => "100",
                    :place => "Some place",
                    :lat => "30",
                    :lng => "100"
                  }, mock_member_session(@member)
                  
    post :create, { :message => "msg",
                    :image => "",
                    :water_height => "100",
                    :place => "Some place",
                    :lat => "30.0004",
                    :lng => "100.0004"
                  }, mock_member_session(@member)
                  
    sleep(1)
    
    post :create, { :message => "msg",
                    :image => "",
                    :water_height => "100",
                    :place => "Some place",
                    :lat => "30.0005",
                    :lng => "100.0005"
                  }, mock_member_session(@member)
                  
    commit_database
    
    groups = PostGroup.asc(:time).entries
    
    groups[0].location[0].should == 30.0000
    groups[0].location[1].should == 100.0000
    
    groups[1].location[0].should == 30.0005
    groups[1].location[1].should == 100.0005
    
  end
  
end
  