# encoding: utf-8
require 'spec_helper'


describe PostController do
  
  include PostControllerRspecHelper
  
  before(:each) do

    @member0 = FacebookMember.create(:facebook_id=>"12345",:name=>"TestMember")
    @member1 = FacebookMember.create(:facebook_id=>"123456",:name=>"TestMember")
    @member2 = FacebookMember.create(:facebook_id=>"123457",:name=>"TestMember")
    @member3 = FacebookMember.create(:facebook_id=>"123458",:name=>"TestMember")
    @member4 = FacebookMember.create(:facebook_id=>"123459",:name=>"TestMember")
    
    @members = [@member0, @member1, @member2, @member3, @member4]

    commit_database
    
  end
  
  
  it "deletes flagged post and pin" do

    post = mock_post(30.0005, 100.0000, 100, @member0)
    commit_database
    
    @members.each { |member|
      xhr :post, :vote, { :id => post.id,
                    :vote => Agreeable::VOTE_DOWN
                  }, mock_member_session(member)
    }
    
    commit_database
    
    Post.all.length.should == 0
    
    PostGroup.all.length.should == 0
    
    flags = FlaggedPost.all
    flags.length.should == 1
    flags[0].id.should == post.id

  end


  it "deletes flagged post and use old post" do

    post0 = mock_post(30.0005, 100.0000, 100, @member0)
    sleep(1)
    post1 = mock_post(30.0005, 100.0000, 99, @member2)
    commit_database
    
    xhr :post, :vote, { :id => post0.id,
                    :vote => Agreeable::VOTE_UP
                  }, mock_member_session(@member0)
    
    @members.each { |member|
      xhr :post, :vote, { :id => post1.id,
                    :vote => Agreeable::VOTE_DOWN
                  }, mock_member_session(member)
    }
    
    posts = Post.all
    posts.length.should == 1
    posts[0].id.should == post0.id
    
    
    post0 = Post.find(post0.id)
    
    
    groups = PostGroup.all
    groups.length.should == 1
    groups[0].water_height.should == post0.water_height
    groups[0].score.should == (post0.voted_up - post0.voted_down)
    
    flags = FlaggedPost.all
    flags.length.should == 1
    flags[0].id.should == post1.id

  end


  it "deletes flagged old post, so the group does not change" do

    post0 = mock_post(30.0005, 100.0000, 100, @member0)
    sleep(1)
    post1 = mock_post(30.0005, 100.0000, 99, @member2)
    commit_database
    
    xhr :post, :vote, { :id => post1.id,
                    :vote => Agreeable::VOTE_UP
                  }, mock_member_session(@member0)
    
    @members.each { |member|
      xhr :post, :vote, { :id => post0.id,
                    :vote => Agreeable::VOTE_DOWN
                  }, mock_member_session(member)
    }
    
    posts = Post.all
    posts.length.should == 1
    posts[0].id.should == post1.id
    
    post1 = Post.find(post1.id)
    
    
    groups = PostGroup.all
    groups.length.should == 1
    groups[0].water_height.should == post1.water_height
    groups[0].score.should == (post1.voted_up - post1.voted_down)
    
    flags = FlaggedPost.all
    flags.length.should == 1
    flags[0].id.should == post0.id

  end


end