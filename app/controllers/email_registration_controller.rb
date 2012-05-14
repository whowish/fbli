class EmailRegistrationController < ApplicationController
  include MemberHelper
  
  def index
    
  end


  def register
    
    params[:email].downcase!

    raise LogicException, {:email=>[word_for(:email_registration,:email_uniqueness)]} if is_email_existed(params[:email])
    
    EmailRegistrationValidator.validate!({:email=>params[:email]}, self)

    Resque.enqueue(FeaturedMemberMailer,:notify_member_confirmation,params[:email])
   
    render :json=>{:ok=>true,:redirect_url=>"/email_registration/please_check_your_email?email=#{params[:email]}"}
  
  rescue LogicException=>e
    render :json=>{:ok=>false,:error_messages=>e.message}
  end


  def confirm_form
    
    params[:email].downcase!
    
    if is_email_existed(params[:email])
      render :already_registered
      return
    end

    @token = EmailRegistrationPending.first(:conditions=>{:email=>params[:email],:_id=>params[:unique_key]})
    
    if !@token
      render :invalid_url
      return 
    end
    
  end


  def confirm
    
    params[:email].downcase!
    
    raise LogicException, word_for(:confirm, :email_uniqueness) if is_email_existed(params[:email])

    token = EmailRegistrationPending.first(:conditions=>{:email=>params[:email],:_id=>params[:unique_key]})
    raise LogicException, word_for(:confirm, :invalid_record) if !token

    ConfirmValidator.validate!(params, self)

    member = UnapproveMember.create(:email=>params[:email],
                          :password=>params[:password],
                          :name=>params[:name],
                          :work_place=>params[:work_place])
    
    
    token.destroy
    #set_member(member)
    render :json=>{:ok=>true,:redirect_url=>"/email_registration/wait_approve"}
    
  rescue LogicException => e
    render :json => {:ok=>false, :error_messages=>e.message}
  end



end
