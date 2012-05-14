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
end
