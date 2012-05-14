module MemberHelper
  
   def process_login(email, password, remember_me, force=false)

    featured_member = FeaturedMember.first(:conditions=>{:email=>email})
    
    raise LogicException, word_for(:login,:invalid) if !featured_member
    raise LogicException, word_for(:login,:invalid) if !featured_member.is_password_valid(password) and !force


    set_member(featured_member, remember_me)
    
  end
  
  def set_member(member, remember_me=false)
    member.save_cookies(session,cookies,remember_me)
    @member = member
  end
  
  def is_email_existed(email)
    is_existed = false
    existed_member = Member.first(:conditions=>{:email=>email})
    existed_unapprove_member = UnapproveMember.first(:conditions=>{:email=>email})
    is_existed = true if existed_member or existed_unapprove_member
    return is_existed
  end

end
