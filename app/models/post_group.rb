class PostGroup
  include Mongoid::Document
  include UniqueIdentity
  
  field :disease_type, :type => String
  field :location, :type => Array
  field :location_string, :type=>String
  field :time, :type => Time, :default=> lambda { Time.now.utc }
  field :views, :type=>Integer, :default=>0
  field :score, :type=>Integer, :default=>0
  
  field :updated_ticket_number, :type=>Integer,:default=>0
  
  index [
          [ :location, Mongo::GEO2D ], 
          [:time,Mongo::DESCENDING ]
        ]
        
  index [
          [ :location, Mongo::GEO2D ], 
          [ :time, Mongo::DESCENDING ],
          [ :water_height, Mongo::DESCENDING ]
        ]
        
  index [[ :location_string, Mongo::ASCENDING ]], :unique => true
  
  
  SIZE = 0.0005
  SIZE_WITHOUT_BORDER = SIZE - 0.0001
  SIZE_DELTA = 0.00005
  
  def update_ticket
    self.inc(:updated_ticket_number, 1)
  end
  
  def self.sanitize_location_unit(unit)

    return SanitizerLocation.sanitize(SIZE, unit)
    
  end
  
  def self.get_from_params(params)
    if params[:id]
      return self.first(:conditions=>{:id=>params[:id]})
    elsif params[:lat] and params[:lng]
      
      params[:lat] = self.sanitize_location_unit(params[:lat].to_f)
      params[:lng] = self.sanitize_location_unit(params[:lng].to_f)
      
      return self.first(:conditions=>{:location=>[params[:lat],params[:lng]]})
    else
      raise 'Invalid query'
    end
  end
  
  
  def center
    return [(location[0] + (SIZE / 2).to_f).round(4), (location[1] + (SIZE / 2).to_f).round(4)]
  end
  
  
  def update_itself(recent_update_post=nil)
    
    posts = Post.where(:post_group_id => self.id).desc(:time).limit(1).entries
    
    return if posts.length == 0 and recent_update_post == nil
    
    if posts.length > 0 
      
      if !recent_update_post or(recent_update_post and recent_update_post.time < posts[0].time) 
        recent_update_post = posts[0]
      end
      
    end
    
    if recent_update_post
      self.time = recent_update_post.time.utc
      self.disease_type = recent_update_post.disease_type
      self.score = recent_update_post.voted_up - recent_update_post.voted_down
      self.save
      
      self.update_ticket
    else
      self.destroy
    end
  end
  
  
  before_create :create_location_string
  
  private
    def create_location_string
      self.location_string = "#{location[0]},#{location[1]}"
    end
  
end