# encoding: utf-8
require 'spec_helper'

describe "ThaiFloodReporter" do
 
  it "add a single record correctly" do
    
    ThaiFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/thai_flood_reporter/thai_flood_reporter_single_record.json"))))

    ThaiFlood::ThaiFloodReporter.initialize_resource

    data = ThaiFlood::ThaiFloodReporter.query
    
    data.each { |row|
      ThaiFlood::ThaiFloodReporter.process(row)
    }
    
    commit_database
    members = Member.all
    members.length.should == 1
    
    members[0].twitter_id.should == "ployzaa202"
    members[0].name.should == "@ployzaa202"
    
    posts = Post.all
    posts.length.should == 1
    
    posts[0].location[0].should == 13.8587
    posts[0].location[1].should == 100.6453
    
    posts[0].message.should == "น้ำท่วม-ห้ามรถเล็ก"
    posts[0].water_height.should == Post::WATER_LEVELS[3]
    
    posts[0].tweet_id.should == "132360883014877184"
    
    posts[0].member_id == members[0].id
    
    checkeds = CheckedTwitter.all
    checkeds.length.should == 1
    checkeds[0].tweet_id.should == "132360883014877184"
    
  end
  
  
  it "add two records with the same member" do

    ThaiFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/thai_flood_reporter/thai_flood_reporter_two_records_with_same_member.json"))))

    ThaiFlood::ThaiFloodReporter.initialize_resource

    data = ThaiFlood::ThaiFloodReporter.query
    
    data.each { |row|
      ThaiFlood::ThaiFloodReporter.process(row)
    }
    
    commit_database
    members = Member.all
    members.length.should == 1
    
    members[0].twitter_id.should == "ployzaa202"
    members[0].name.should == "@ployzaa202"
    
    posts = Post.all
    posts.length.should == 2
    
    posts[0].member_id == members[0].id
    posts[1].member_id == members[0].id
    
    checkeds = CheckedTwitter.all
    checkeds.length.should == 2
    checkeds[0].tweet_id.should == "132360883014877184"
    checkeds[1].tweet_id.should == "132360883014877185"

  end
  
  
  it "does not add redundant record" do
    
  
    ThaiFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/thai_flood_reporter/thai_flood_reporter.json"))))

    ThaiFlood::ThaiFloodReporter.initialize_resource
    
    2.times {
      data = ThaiFlood::ThaiFloodReporter.query
      
      data.each { |row|
        ThaiFlood::ThaiFloodReporter.process(row)
      }
      
      commit_database
      Member.all.length.should == 5
      
      Post.all.length.should == 5
      
      CheckedTwitter.all.length.should == 5
    }
    
  end
  
  
  it "does not add record without google map link" do

    ThaiFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/thai_flood_reporter/thai_flood_reporter_without_google_map.json"))))

    ThaiFlood::ThaiFloodReporter.initialize_resource

    data = ThaiFlood::ThaiFloodReporter.query
    
    data.each { |row|
      ThaiFlood::ThaiFloodReporter.process(row)
    }
    
    commit_database
    Member.all.length.should ==0
    
    Post.all.length.should == 0
    CheckedTwitter.all.length.should == 0

  end
  
  
end
  