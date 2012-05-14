
ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => DOMAIN_NAME,
  :user_name            => 'whowish@gmail.com',
  :password             => 'whowish123',
  :authentication       => 'plain',
  :enable_starttls_auto => true  
}