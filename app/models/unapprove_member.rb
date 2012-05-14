require 'bcrypt'
class UnapproveMember
  include Mongoid::Document
  include UniqueIdentity
  
  field :email, :type => String
  field :password, :type => String, :default=>""
  field :work_place, :type => String
  field :name, :type => String
  field :global_id, :type => String
  

  index [[ "email", Mongo::ASCENDING ]]
  
  def is_password_valid(password)
    password_hash = BCrypt::Password.new(self.password)
    return (password_hash == password)
  rescue
    return false
  end
  
  def url
    ""
  end
  
  before_create :encrypt_password_before_create
  
  def self.encrypt_password(password)
    return BCrypt::Password.create(password).to_s
  end
  
  private
  def encrypt_password_before_create
    self.password = self.class.encrypt_password(self.password)
  end
  
  def create_global_id
    self.global_id = "unapprove_#{self.email}"
  end
  
end