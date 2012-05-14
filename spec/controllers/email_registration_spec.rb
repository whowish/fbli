# encoding: utf-8
require 'spec_helper'

describe EmailRegistrationController do


  it "register correctly" do

    post :register, {:email=>"test@gmail.com"}

    body = expect_json_response
    body.should be_ok
    commit_database

    expect_and_perform_queue(:normal, 1)

    pendings = EmailRegistrationPending.all
    pendings.length.should == 1
    pendings[0].email.should == "test@gmail.com"

    ActionMailer::Base.deliveries.length.should == 1
    ActionMailer::Base.deliveries[0].to.should == ["test@gmail.com"]

  end


  it "register two times with different emails" do

    post :register, {:email=>"test@gmail.com"}

    body = expect_json_response
    body.should be_ok
    commit_database
    
    post :register, {:email=>"test2@gmail.com"}

    body = expect_json_response
    body.should be_ok
    commit_database

    expect_and_perform_queue(:normal, 2)

    pendings = EmailRegistrationPending.all
    pendings.map { |i| i.email }.should =~ ["test@gmail.com", "test2@gmail.com"]

    ActionMailer::Base.deliveries.length.should == 2
    ActionMailer::Base.deliveries[0].to.should == ["test@gmail.com"]
    ActionMailer::Base.deliveries[1].to.should == ["test2@gmail.com"]

  end


  it "register correctly even submitting twice" do

    post :register, {:email=>"test@gmail.com"}

    body = expect_json_response
    body.should be_ok
    commit_database
    
    expect_and_perform_queue(:normal, 1)
    
    post :register, {:email=>"test@gmail.com"}

    body = expect_json_response
    body.should be_ok
    commit_database

    expect_and_perform_queue(:normal, 1)

    pendings = EmailRegistrationPending.all
    pendings.length.should == 1
    pendings[0].email.should == "test@gmail.com"

    ActionMailer::Base.deliveries.length.should == 2
    ActionMailer::Base.deliveries[0].to.should == ["test@gmail.com"]
    ActionMailer::Base.deliveries[1].to.should == ["test@gmail.com"]

  end


  it "does not register because this email is already a member" do
    
    HotelMember.create(:email=>"test@gmail.com",:password=>"")
    
    post :register, {:email=>"test@gmail.com"}

    body = expect_json_response
    body.should_not be_ok
    body.should have_error(:email, WhowishWord.word_for(:email_registration, :email_uniqueness, :th))
    commit_database
    
    ActionMailer::Base.deliveries.length.should == 0
    
  end


  it "validates email if it is not present" do
    
    post :register, {:email=>""}

    body = expect_json_response
    body.should_not be_ok
    body.should have_error(:email, WhowishWord.word_for(:email_registration, :email_presence, :th))
    commit_database
    
    ActionMailer::Base.deliveries.length.should == 0
    
  end


  it "validates email if it is not valid" do

    post :register, {:email=>"qegwegew"}

    body = expect_json_response
    body.should_not be_ok
    body.should have_error(:email, WhowishWord.word_for(:email_registration, :email_email, :th))
    commit_database
    
    ActionMailer::Base.deliveries.length.should == 0

  end

end