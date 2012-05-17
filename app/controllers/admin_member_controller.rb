class AdminMemberController < ApplicationController
  include AdminMemberHelper
  
  def index
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
