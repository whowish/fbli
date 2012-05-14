class FlaggedPost
  include Mongoid::Document
  
  identity :type => String

  def self.move(post)
    
    self.create(post.attributes)
    
    post.destroy
    
  end

end