class EmailRegistrationValidator < Validator::Base

  register_validation :email, [presence,
                                nil,
                                email]
  
end