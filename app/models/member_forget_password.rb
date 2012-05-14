class MemberForgetPassword
  include Mongoid::Document
  include UniqueIdentity

  field :featured_member_id, :type=>String
  field :created_date, :type => DateTime
  index [[:featured_member_id, Mongo::DESCENDING ],
         [:_id, Mongo::DESCENDING ]]

  before_create :stamp
  
  private
  def stamp
    self.created_date = Time.now
  end

end