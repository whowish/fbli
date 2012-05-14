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
  
  it "creates post twice with image and without image" do

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


    @member = FacebookMember.find(@member.id)
    @member.all_score.should == Post::SCORE_UPLOAD_PIC + Post::SCORE_NOPIC

    location_group = ScorePerDay.get_location_group([30,100])
    score = ScorePerDay.get(@member.id, Time.now, location_group)
    score.score.should == Post::SCORE_UPLOAD_PIC + Post::SCORE_NOPIC

    max = MaxScorePerDayPerArea.get(location_group, Time.now)
    max.score.should == Post::SCORE_UPLOAD_PIC + Post::SCORE_NOPIC
    max.member_id.should == @member.id

  end
  
  
  it "creates post twice on different day" do

    today = Time.now
    yesterday = Time.now - 86402

    Time.stub!(:now).and_return(yesterday)

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

    Time.stub!(:now).and_return(today)

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


    @member = FacebookMember.find(@member.id)
    @member.all_score.should == Post::SCORE_UPLOAD_PIC + Post::SCORE_NOPIC

    location_group = ScorePerDay.get_location_group([30,100])
    score = ScorePerDay.get(@member.id, yesterday.in_time_zone,location_group)
    score.score.should == Post::SCORE_UPLOAD_PIC

    score = ScorePerDay.get(@member.id, today.in_time_zone,location_group)
    score.score.should == Post::SCORE_NOPIC

    max = MaxScorePerDayPerArea.get(location_group, yesterday.in_time_zone)
    max.score.should == Post::SCORE_UPLOAD_PIC
    max.member_id.should == @member.id

    max = MaxScorePerDayPerArea.get(location_group, today.in_time_zone)
    max.score.should == Post::SCORE_NOPIC
    max.member_id.should == @member.id

  end


end
  