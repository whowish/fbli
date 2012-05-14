module AdminMemberHelper
  def approve_member(member)
    approve_member = FeaturedMember.create(:email=>member.email,
                          :password=>member.password,
                          :name=>member.name,
                          :work_place=>member.work_place)
                          
    member.destroy
  end
end
