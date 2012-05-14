class FeaturedMemberMailer < ActionMailer::Base
  
  
  
  # Resque
  #
  #
  #
  @queue = :normal

  def self.perform(method,*args)
    Rails.logger.info { "This job is run in #{Rails.env}" }
    self.send(method,*args).deliver
  end

  layout "blank"

  # Tasks
  # 
  #
  #
  def notify_member_confirmation(email)   
    
    token = EmailRegistrationPending.first(:conditions=>{:email=>email})
    
    if !token
      token = EmailRegistrationPending.create(:email=>email)
      
      error = Mongoid.database.command({:getlasterror => 1})
      
      # There is a concurrent insertion occurs at the same time.
      if error['code'].to_i == 11000
        token = EmailRegistrationPending.first(:conditions=>{:email=>email})
      end
    end


    @url = "http://#{DOMAIN_NAME}/email_registration/confirm_form?email=#{email}&unique_key=#{token.id}"
    
    mail(:to => email,
         :from => "Disease Report <#{EMAIL}>",
         :subject => "You've registered. Please confirm your registration.",
         :content_type => "text/html"
         )

  end


  def notify_member_forget_password(email)   

    featured_member = FeaturedMember.first(:conditions=>{:email=>email})   
    return if !featured_member

    token = MemberForgetPassword.create(:featured_member_id=>featured_member.id)  

    @url = "http://#{DOMAIN_NAME}/member/recover_password_form?email=#{featured_member.email}&unique_key=#{token.id}"


   mail(:to => featured_member.email,
         :from => "Disease Report <#{EMAIL}>",
         :subject => "Password Recovery",
         :content_type => "text/html"
         )


  end
end