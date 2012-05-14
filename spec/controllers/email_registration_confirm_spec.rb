# encoding: utf-8
require 'spec_helper'

describe EmailRegistrationController do


  it "shows confirm form correctly" do

    pending = EmailRegistrationPending.create(:email=>"test@gmail.com")

    get :confirm_form, {:email=>pending.email, :unique_key=>pending.id}

    assigns(:existed_member).should be_nil
    assigns(:token).should_not be_nil

  end


  it "does not show confirm form because email is already registered" do

    HotelMember.create(:email=>"test@gmail.com",:password=>"test")
    pending = EmailRegistrationPending.create(:email=>"test@gmail.com")

    get :confirm_form, {:email=>pending.email, :unique_key=>pending.id}

    assigns(:existed_member).email.should == "test@gmail.com"
    assigns(:token).should be_nil

  end


  it "does not show confirm form because token is not valid" do

    pending = EmailRegistrationPending.create(:email=>"test@gmail.com")

    get :confirm_form, {:email=>pending.email, :unique_key=>"AAAA"}

    assigns(:existed_member).should be_nil
    assigns(:token).should be_nil

  end


  it "confirm correctly" do
    
    pending = EmailRegistrationPending.create(:email=>"test@gmail.com")
    commit_database
    
    post :confirm, {:email=>pending.email, 
                    :unique_key=>pending.id,
                    :featured_type=>"restaurant",
                    :password=>"password",
                    :name=>"Name",
                    :address=>"Address",
                    :phone=>"Phone",
                    :site=>"Site"
                    }

    body = expect_json_response
    body.should be_ok
    commit_database

    members = RestaurantMember.all
    members.length.should == 1
    
    members[0].email.should == pending.email
    members[0].name.should == "Name"
    members[0].address.should == "Address"
    members[0].phone.should == "Phone"
    members[0].site.should == "Site"
    
    EmailRegistrationPending.all.length.should == 0


  end


  it "cannot confirm because the email is registered" do

    HotelMember.create(:email=>"test@gmail.com",:password=>"test")
    pending = EmailRegistrationPending.create(:email=>"test@gmail.com")
    commit_database
    
    post :confirm, {:email=>pending.email, 
                    :unique_key=>pending.id,
                    :featured_type=>"restaurant",
                    :password=>"password",
                    :name=>"Name",
                    :address=>"Address",
                    :phone=>"Phone",
                    :site=>"Site"
                    }

    body = expect_json_response
    body.should_not be_ok
    body.should have_error(WhowishWord.word_for(:confirm, :email_uniqueness, :th))

  end


  it "cannot confirm because the token is not valid" do
    
    pending = EmailRegistrationPending.create(:email=>"test@gmail.com")
    commit_database
    
    post :confirm, {:email=>pending.email, 
                    :unique_key=>"XXX",
                    :featured_type=>"restaurant",
                    :password=>"password",
                    :name=>"Name",
                    :address=>"Address",
                    :phone=>"Phone",
                    :site=>"Site"
                    }

    body = expect_json_response
    body.should_not be_ok
    body.should have_error(WhowishWord.word_for(:confirm, :invalid_record, :th))
    
  end


  it "cannot confirm because the type is not valid" do
    
    pending = EmailRegistrationPending.create(:email=>"test@gmail.com")
    commit_database
    
    post :confirm, {:email=>pending.email, 
                    :unique_key=>pending.id,
                    :featured_type=>"aaa",
                    :password=>"password",
                    :name=>"aa",
                    :address=>"aa",
                    :phone=>"aa",
                    :site=>"aa"
                    }

    body = expect_json_response
    body.should_not be_ok
    body.should have_error(WhowishWord.word_for(:confirm, :invalid_type, :th))

  end

  it "cannot confirm because fields are not valid" do
    
    pending = EmailRegistrationPending.create(:email=>"test@gmail.com")
    commit_database
    
    post :confirm, {:email=>pending.email, 
                    :unique_key=>pending.id,
                    :featured_type=>"restaurant",
                    :password=>"password",
                    :name=>"",
                    :address=>"",
                    :phone=>"",
                    :site=>""
                    }

    body = expect_json_response
    body.should_not be_ok
    body.should have_error(:name, WhowishWord.word_for(:confirm, :name_presence, :th))
    body.should have_error(:address, WhowishWord.word_for(:confirm, :address_presence, :th))
    body.should have_error(:phone, WhowishWord.word_for(:confirm, :phone_presence, :th))
    body.should have_error(:site, WhowishWord.word_for(:confirm, :site_presence, :th))

  end


end