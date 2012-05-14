# encoding: utf-8
require 'spec_helper'

describe "GamlingFlood" do
  
  
  it "adds a record correctly" do
    
    ThaiFlood::GamlingFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/gamling_flood/twitter_single_record.json"))))

    ThaiFlood::GamlingFlood.initialize_resource

    data = ThaiFlood::GamlingFlood.query
    
    data.each { |row|
      ThaiFlood::GamlingFlood.process(row)
    }
    
    commit_database
    members = Member.all
    members.length.should == 1
    
    members[0].twitter_id.should == "tanin47"
    members[0].name.should == "@tanin47"
    
    groups = PostGroup.all
    groups.length.should == 1
    groups[0].location[0].should == 13.7365
    groups[0].location[1].should == 100.5845
    groups[0].water_height.should == Post::WATER_LEVELS[0]
    
    posts = Post.all
    posts.length.should == 1

    posts[0].location[0].should == 13.7369
    posts[0].location[1].should == 100.5847
    posts[0].post_group_id.should == groups[0].id
    
    posts[0].message.should == "@gamlingflood tesy "
    posts[0].water_height.should == Post::WATER_LEVELS[0]
    
    posts[0].tweet_image_url.should == "http://twitgoo.com/4ub2tx/img"
    posts[0].tweet_id.should == "134359593060024321"
    
    posts[0].member_id == members[0].id
    
    checkeds = CheckedTwitter.all
    checkeds.length.should == 1
    checkeds[0].tweet_id == "134359593060024321"
    
  end
  
  
  it 'adds record that has no image' do
    
    ThaiFlood::GamlingFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/gamling_flood/twitter_single_record_no_image.json"))))

    ThaiFlood::GamlingFlood.initialize_resource

    data = ThaiFlood::GamlingFlood.query
    
    data.each { |row|
      ThaiFlood::GamlingFlood.process(row)
    }
    
    commit_database
    members = Member.all
    members.length.should == 1
    
    members[0].twitter_id.should == "tanin47"
    members[0].name.should == "@tanin47"
    
    groups = PostGroup.all
    groups.length.should == 1
    groups[0].location[0].should == 13.7365
    groups[0].location[1].should == 100.5845
    groups[0].water_height.should == Post::WATER_LEVELS[0]
    
    posts = Post.all
    posts.length.should == 1

    posts[0].location[0].should == 13.7369
    posts[0].location[1].should == 100.5847
    posts[0].post_group_id.should == groups[0].id
    
    posts[0].message.should == "@gamlingflood tesy"
    posts[0].water_height.should == Post::WATER_LEVELS[0]
    
    posts[0].tweet_image_url.should be_nil
    posts[0].tweet_id.should == "134359593060024321"
    
    posts[0].member_id == members[0].id
    
    checkeds = CheckedTwitter.all
    checkeds.length.should == 1
    checkeds[0].tweet_id == "134359593060024321"
    
  end


  it "adds two records with the same member" do

    ThaiFlood::GamlingFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/gamling_flood/twitter_two_records_with_the_same_member.json"))))

    ThaiFlood::GamlingFlood.initialize_resource

    data = ThaiFlood::GamlingFlood.query
    
    data.each { |row|
      ThaiFlood::GamlingFlood.process(row)
    }
    
    commit_database
    members = Member.all
    members.length.should == 1
    
    members[0].twitter_id.should == "tanin47"
    members[0].name.should == "@tanin47"
    
    posts = Post.all
    posts.length.should == 2
    
    posts[0].member_id == members[0].id
    posts[1].member_id == members[0].id
    
    checkeds = CheckedTwitter.all
    checkeds.length.should == 2
    checkeds[0].tweet_id == "134359593060024321"
    checkeds[1].tweet_id == "134359593060024322"

  end

  
  it "does not add redundant record" do

    ThaiFlood::GamlingFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/gamling_flood/twitter.json"))))

    ThaiFlood::GamlingFlood.initialize_resource

    2.times {
      data = ThaiFlood::GamlingFlood.query
      
      data.each { |row|
        ThaiFlood::GamlingFlood.process(row)
      }
      
      commit_database
      members = Member.all
      members.length.should == 1
      
      posts = Post.all
      posts.length.should == 2
      
      CheckedTwitter.all.length == 2
    }

  end
  
  
  it "does not add record with no location" do
    
    ThaiFlood::GamlingFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/gamling_flood/twitter_without_location.json"))))

    ThaiFlood::GamlingFlood.initialize_resource

    data = ThaiFlood::GamlingFlood.query
    
    data.each { |row|
      ThaiFlood::GamlingFlood.process(row)
    }
    
    commit_database
    members = Member.all
    members.length.should == 0
    
    posts = Post.all
    posts.length.should == 0
    
    CheckedTwitter.all.length == 0
    
  end
  
end
  