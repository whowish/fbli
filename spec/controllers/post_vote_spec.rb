# encoding: utf-8
require 'spec_helper'

describe PostController do
  
  before(:each) do
    
    @member = FacebookMember.create(:facebook_id=>"12345",:name=>"TestMember2")
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
  
  
  it "votes up" do
    
    xhr :post, :vote, { :id => @post.id,
                  :vote => Agreeable::VOTE_UP
                }, mock_member_session(@member2)
                
    body = expect_json_response
    body.should be_ok
    commit_database
    
    @post = Post.find(@post.id)
    @post.voted_up.should == 1
    @post.voted_down.should == 0
    
    @post.is_vote_up_or_down(@member2.id).should == Agreeable::VOTE_UP
    
  end
  
  
  it "votes down" do
    
    xhr :post, :vote, { :id => @post.id,
                  :vote => Agreeable::VOTE_DOWN
                }, mock_member_session(@member2)
                
    body = expect_json_response
    body.should be_ok
    commit_database
    
    @post = Post.find(@post.id)
    @post.voted_up.should == 0
    @post.voted_down.should == 1
    
    @post.is_vote_up_or_down(@member2.id).should == Agreeable::VOTE_DOWN
    
  end
  
  
  it "changes from up to down" do
    
    xhr :post, :vote, { :id => @post.id,
                  :vote => Agreeable::VOTE_UP
                }, mock_member_session(@member2)
    
    xhr :post, :vote, { :id => @post.id,
                  :vote => Agreeable::VOTE_DOWN
                }, mock_member_session(@member2)
                

    body = expect_json_response
    body.should be_ok
    commit_database
    
    @post = Post.find(@post.id)
    @post.voted_up.should == 0
    @post.voted_down.should == 1
    
    @post.is_vote_up_or_down(@member2.id).should == Agreeable::VOTE_DOWN
    
  end
  
  
  it "changes from down to up" do
    
    xhr :post, :vote, { :id => @post.id,
                  :vote => Agreeable::VOTE_DOWN
                }, mock_member_session(@member2)
    
    xhr :post, :vote, { :id => @post.id,
                  :vote => Agreeable::VOTE_UP
                }, mock_member_session(@member2)
                

    body = expect_json_response
    body.should be_ok
    commit_database
    
    @post = Post.find(@post.id)
    @post.voted_up.should == 1
    @post.voted_down.should == 0
    
    @post.is_vote_up_or_down(@member2.id).should == Agreeable::VOTE_UP
    
  end
  
  
  it "votes by guest" do
    
    xhr :post, :vote, { :id => @post.id,
                  :vote => Agreeable::VOTE_UP
                }, {}
                
    body = expect_json_response
    body.should_not be_ok
    
  end
  
end