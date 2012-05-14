class ConfirmValidator < Validator::Base


  register_validation :email, [presence,
                                nil,
                                email]

  register_validation :password, [presence]
  register_validation :name, [presence]
  register_validation :work_place, [presence]
 

end