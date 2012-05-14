class EmailRegistrationPending
  include Mongoid::Document
  include UniqueIdentity

  field :email, :type=>String
  
  index :email, :unique=>true
  
  index [[:email, Mongo::DESCENDING ],
         [:_id, Mongo::DESCENDING ]]

end