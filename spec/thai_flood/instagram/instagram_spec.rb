# encoding: utf-8
require 'spec_helper'

describe "Instagram" do
  
  it "add a single record correctly" do
    
    
    ThaiFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/instagram/instagram_single_record.json"))))

    data = ThaiFlood::Instagram.query
    
    data.each { |row|
      ThaiFlood::Instagram.process(row)
    }
    
    commit_database
    
    members = Member.all
    members.length.should == 1
    members[0].instagram_user_id.should == "12440130"
    members[0].name.should == "chariyapat"
    
    posts = Post.all
    posts.length.should == 1
    
    posts[0].member_id == members[0].id
    
    posts[0].location[0].should == 13.8825
    posts[0].location[1].should == 100.6482
    
    posts[0].place.should == "ทางพิเศษฉลองรัช"
    
    posts[0].instagram_image_url.should == "http://distilleryimage6.instagram.com/0e0c228206b211e180c9123138016265_6.jpg"
    posts[0].instagram_media_id.should == "313090254_12440130"
    
    posts[0].message.should == "ด่านทางด่วนสุขาภิบาล5 น้ำท่วมถึงเข่าแล้ว#gamling "
    posts[0].water_height.should == Post::WATER_LEVELS[2]
    
    checkeds = CheckedInstagram.all
    checkeds.length.should == 1
    checkeds[0].instagram_media_id.should == "313090254_12440130"
    
  end
  
  
  it "add two records with the same member" do
    
    
    ThaiFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/instagram/instagram_two_records_with_same_member.json"))))

    data = ThaiFlood::Instagram.query
    
    data.each { |row|
      ThaiFlood::Instagram.process(row)
    }
    
    commit_database
    
    members = Member.all
    members.length.should == 1
    members[0].instagram_user_id.should == "12440130"
    members[0].name.should == "chariyapat"
    
    posts = Post.all
    posts.length.should == 2
    
    posts[0].member_id == members[0].id
    posts[1].member_id == members[0].id
    
    checkeds = CheckedInstagram.all
    checkeds.length.should == 2
    checkeds[0].instagram_media_id.should == "313090254_12440130"
    checkeds[1].instagram_media_id.should == "313090254_12440131"
    
  end
  
  
  it "gets Instagram and add all the records" do
    
    # with 2 no-location records
    
    ThaiFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/instagram/instagram.json"))))

    ThaiFlood::Instagram.initialize_resource

    data = ThaiFlood::Instagram.query
    
    data.each { |row|
      ThaiFlood::Instagram.process(row)
    }
    
    commit_database
    posts = Post.all
    posts.length.should == 18
    
    posts.each { |post|
      post.instagram_image_url.should_not be_nil
    }
    
    checkeds = CheckedInstagram.all
    checkeds.length.should == 18

  end
  
  
  it "ignores redundant record" do
    
    # with 2 no-location records
    
    ThaiFlood.stub(:get_json).and_return(ActiveSupport::JSON.decode(IO.read(File.join(Rails.root,"spec/thai_flood/instagram/instagram.json"))))
    
    ThaiFlood::Instagram.initialize_resource
    
    2.times {

      data = ThaiFlood::Instagram.query
      
      data.each { |row|
        ThaiFlood::Instagram.process(row)
      }
      
      commit_database
      posts = Post.all
      posts.length.should == 18
      
      posts.each { |post|
        post.instagram_image_url.should_not be_nil
      }
    
      checkeds = CheckedInstagram.all
      checkeds.length.should == 18
    }
    
  end
  
end
  