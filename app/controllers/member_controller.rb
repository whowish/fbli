class MemberController < ApplicationController
  include MemberHelper


  def login
 
    params[:redirect_url] ||= "/post/create_form/#{params[:lat]}/#{params[:lng]}"
    params[:redirect_url] = "/post/create_form/#{params[:lat]}/#{params[:lng]}" if params[:redirect_url] == ""
    
    process_login(params[:email], params[:password], params[:remember_me]=="yes")
    
    render :json=>{:ok=>true, :redirect_url=>params[:redirect_url]}
    
  rescue LogicException => e
    render :json=>{:ok=>false, :error_messages=>e.message}
  end

  def change_password_form
    if @member.is_guest
      params[:redirect_url] = "/member/change_password_form"
      render :template => 'home/login_required'
      return
    end
  end

  def change_password
    
    raise LogicException, word_for(:change_password,:invalid) if !@member.is_password_valid(params[:password])
    raise LogicException, word_for(:change_password,:please_specify_new_password) and return if params[:new_password].strip == ""
    
   
    @member.password = FeaturedMember.encrypt_password(params[:new_password])
    @member.save
    
    render :json=>{:ok=>true}
    
  rescue LogicException=>e
    render :json=>{:ok=>false,:error_message=>e.message}
  end


  def forget_password
    
    featured_member = FeaturedMember.first(:conditions=>{:email=>params[:email]})
    
    raise LogicException, word_for(:forget_password, :email_invalid) if !featured_member
    
    Resque.enqueue(FeaturedMemberMailer,:notify_member_forget_password,params[:email])
    
    render :json=>{:ok=>true}
  rescue LogicException => e
    render :json=>{:ok=>false, :error_messages=>e.message}
  end


  def recover_password_form
    
    featured_member = FeaturedMember.first(:conditions=>{:email=>params[:email]})
    raise LogicException if !featured_member

    token = MemberForgetPassword.first(:conditions=>{:featured_member_id=>featured_member.id,:_id=>params[:unique_key]})
    raise LogicException if !token
    
  rescue LogicException => e
    @invalid = true
    render :invalid_url
  end


  def recover_password
    
    params[:password] = params[:password].strip
    
    featured_member = FeaturedMember.first(:conditions=>{:email=>params[:email]})
    raise LogicException, word_for(:recover_password, :invalid) if !featured_member

    token = MemberForgetPassword.first(:conditions=>{:featured_member_id=>featured_member.id,:_id=>params[:unique_key]})
    raise LogicException, word_for(:recover_password, :invalid) if !token
    raise LogicException, word_for(:recover_password, :password_presence) if params[:password] == ""
    
    
    featured_member.password = FeaturedMember.encrypt_password(params[:password])
    featured_member.save
    token.destroy
    
    process_login(featured_member.email, featured_member.password, false, true)
    
    render :json=>{:ok=>true}
    
  rescue LogicException => e
    render :json=>{:ok=>false,:error_messages=>e.message}
  end

  def profile
    if @member.is_guest
      params[:redirect_url] = "/member/profile"
      render :template => 'home/login_required'
      return
    end
  end
  
  def edit

    @member.update_attributes(:name=>params[:name], 
                            :work_place => params[:work_place])
                             
                            
    render :json=>{:ok=>true}
  rescue LogicException => e
    render :json=>{:ok=>false,:error_messages=>e.message}     
  end
  
  

end
