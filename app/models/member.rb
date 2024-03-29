class Member < User
  include Mongoid::Document
  include UniqueIdentity
  include MemberCookies
  
  field :name, :type => String
  field :global_id, :type => String
  
  field :is_admin, :type => Boolean, :default=>false
  field :created_date, :type => Time, :default => lambda{ Time.now.utc }
  field :all_score, :type => Integer, :default=>0
  
  index [[:global_id, Mongo::ASCENDING]], :unique=>true, :sparse=>true
  
  def self.get_member_from_session(session, cookies)
    return self.get_member_from_cookies(session,cookies)
  rescue Exception=>e
    return Guest.new
  end

 
  def is_guest
    return false
  end

end