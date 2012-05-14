module MemberRspecHelper

  def mock_member_session(member)
    return {
            :member_id => member.id,
            :member_signature => Member.generate_cookies_signature(member.id,member.cookies_salt)
           }  
  end
  
end