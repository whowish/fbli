# encoding: utf-8
require 'spec_helper'

describe MemberController do


  it "logins correctly" do
    
    member = HotelMember.create(:email=>"test@test.com",:password=>"test")
    commit_database

    post :login, {:email=>"test@test.com",
                  :password=>"test",
                  :remember_me=>"yes",
                  :redirect_url=>"/test"}

    body = expect_json_response
    body.should be_ok
    body['redirect_url'].should == "/test"

  end


  it "validates username and password" do

    member = HotelMember.create(:email=>"test@test.com",:password=>"test")
    commit_database

    post :login, {:email=>"test@test.com",
                  :password=>"test123",
                  :remember_me=>"yes",
                  :redirect_url=>"/test123"}

    body = expect_json_response
    body.should_not be_ok
    body.should have_error(WhowishWord.word_for(:login, :invalid, :th))

  end


  it "forget password correctly" do

    member = HotelMember.create(:email=>"test@test.com",:password=>"test")
    commit_database

    post :forget_password, {:email=>"test@test.com"}
    
    body = expect_json_response
    body.should be_ok
    commit_database
    
    expect_and_perform_queue(:normal, 1)
    
    forgets = MemberForgetPassword.all
    forgets.length.should == 1
    forgets[0].featured_member_id.should == member.id
    
    ActionMailer::Base.deliveries.length.should == 1
    ActionMailer::Base.deliveries[0].to.should == ["test@test.com"]

  end


  it "validates email to forget password" do

    member = HotelMember.create(:email=>"test@test.com",:password=>"test")
    commit_database

    post :forget_password, {:email=>"afsasf"}
    
    body = expect_json_response
    body.should_not be_ok
    body.should have_error(WhowishWord.word_for(:forget_password, :email_invalid, :th))

  end


  it "shows recover password form correctly" do

    member = HotelMember.create(:email=>"test@test.com",:password=>"test")
    forget = MemberForgetPassword.create(:featured_member_id=>member.id)
    commit_database

    get :recover_password_form, {:email=>member.email,
                                  :unique_key=>forget.id}
                                  
    assigns(:invalid).should be_nil

  end


  it "does not show recover password form" do

    member = HotelMember.create(:email=>"test@test.com",:password=>"test")
    forget = MemberForgetPassword.create(:featured_member_id=>member.id)
    commit_database

    get :recover_password_form, {:email=>member.email,
                                  :unique_key=>"AAAA."}
                                  
    assigns(:invalid).should == true

  end


  it "does not show recover password form" do

    member = HotelMember.create(:email=>"test@test.com",:password=>"test")
    forget = MemberForgetPassword.create(:featured_member_id=>member.id)
    commit_database

    get :recover_password_form, {:email=>"aaa",
                                  :unique_key=>forget.id}
                                  
    assigns(:invalid).should == true

  end


  it "recovers password correctly" do
    
    member = HotelMember.create(:email=>"test@test.com",:password=>"test")
    forget = MemberForgetPassword.create(:featured_member_id=>member.id)
    commit_database

    post :recover_password, {:email=>member.email,
                            :unique_key=>forget.id,
                            :password=>"abcd"}
                                  
    body = expect_json_response
    body.should be_ok
    commit_database
    
    member = Member.find(member.id)
    member.is_password_valid("abcd").should == true
    
    MemberForgetPassword.all.length.should == 0
    
  end


  it "does not show recover password" do

    member = HotelMember.create(:email=>"test@test.com",:password=>"test")
    forget = MemberForgetPassword.create(:featured_member_id=>member.id)
    commit_database

    post :recover_password, {:email=>member.email,
                             :unique_key=>"AAAA.",
                             :password=>"abcd"}
                                  
    body = expect_json_response
    body.should_not be_ok
    body.should have_error(WhowishWord.word_for(:recover_password, :invalid, :th))

  end


  it "does not show recover password" do

    member = HotelMember.create(:email=>"test@test.com",:password=>"test")
    forget = MemberForgetPassword.create(:featured_member_id=>member.id)
    commit_database

    post :recover_password, {:email=>"adsdee",
                             :unique_key=>forget.id,
                             :password=>"abcd"}
                                  
    body = expect_json_response
    body.should_not be_ok
    body.should have_error(WhowishWord.word_for(:recover_password, :invalid, :th))

  end


  it "does not show recover password" do

    member = HotelMember.create(:email=>"test@test.com",:password=>"test")
    forget = MemberForgetPassword.create(:featured_member_id=>member.id)
    commit_database

    post :recover_password, {:email => member.email,
                             :unique_key => forget.id,
                             :password=>""}
                                  
    body = expect_json_response
    body.should_not be_ok
    body.should have_error(WhowishWord.word_for(:recover_password, :password_presence, :th))

  end

end