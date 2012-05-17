class AdminMemberController < ApplicationController
  include AdminMemberHelper
  
  def index
    params[:redirect_url] ||= "/admin_member"
    if @member.is_guest or !@member.is_admin
       render :template => 'home/login_required'
      return
    end
    
    @pending_members = UnapproveMember.all()
  end
  
  def confirm_approve_member
    pending_member_ids = params[:member_id].split(',');
    pending_member_ids.each do |id|
      member = UnapproveMember.first(:conditions=>{:_id => id})
      approve_member(member)
    end
    render :json=>{:ok=>true}
  end
  
  def set_admin
    params[:redirect_url] ||= "/admin_member/set_admin"
    if (@member.is_guest or !@member.is_admin) and !Rails.env.development?
       render :template => 'home/login_required'
      return
    end
    
    @members = Member.where(:is_admin=>false).entries
  end
  
  def submit_set_admin
    member_ids = params[:member_id].split(',');
    member_ids.each do |id|
      member = FeaturedMember.first(:conditions=>{:_id => id})
      member.is_admin = true
      member.save
    end
    render :json=>{:ok=>true}
  end
  
  def remove_admin
    params[:redirect_url] ||= "/admin_member/remove_admin"
    if @member.is_guest or !@member.is_admin
       render :template => 'home/login_required'
      return
    end
    @admins = Member.where(:is_admin=>true).entries
  end
  
  def submit_remove_admin
    member_ids = params[:member_id].split(',');
    member_ids.each do |id|
      member = FeaturedMember.first(:conditions=>{:_id => id})
      member.is_admin = false
      member.save
    end
    render :json=>{:ok=>true}
  end
end
