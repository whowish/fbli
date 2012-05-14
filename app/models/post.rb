class Post
  include Mongoid::Document
  include UniqueIdentity
  include Agreeable
  
 
  SCORE_NOPIC = 1
  SCORE_UPLOAD_PIC = 10
  
  DISEASE_CHIKUNGUNYA = "CHIKUNGUNYA"
  DISEASE_DENGUE_FEVER = "DENGUE"
  DISEASE_MALARIA = "MALARIA"
  DISEASE_LEPTO = "LEPTOSPIROSIS"
  DISEASE_DENGUE_FEVER_1 = "D1"
  DISEASE_DENGUE_FEVER_2 = "D2"
  DISEASE_DENGUE_FEVER_3 = "D3"
  DISEASE_DENGUE_FEVER_4 = "D4"
  
  DISEASE_TYPE = [DISEASE_CHIKUNGUNYA,DISEASE_DENGUE_FEVER,DISEASE_MALARIA,DISEASE_LEPTO]
  DENGUE_TYPE = [DISEASE_DENGUE_FEVER_1,DISEASE_DENGUE_FEVER_2,DISEASE_DENGUE_FEVER_3,DISEASE_DENGUE_FEVER_4]
  DISEASE_FILTER = [DISEASE_CHIKUNGUNYA,DISEASE_DENGUE_FEVER,DISEASE_DENGUE_FEVER_1,DISEASE_DENGUE_FEVER_2,DISEASE_DENGUE_FEVER_3,DISEASE_DENGUE_FEVER_4,DISEASE_MALARIA,DISEASE_LEPTO]
 
 
  GENDER_MALE = "MALE"
  GENDER_FEMALE = "FEMALE"
  
  GENDER_TYPE = [GENDER_MALE,GENDER_FEMALE]
  
  field :message, :type => String
  field :image, :type => String
  field :place, :type => String
  field :address, :type => String
  field :post_group_id, :type => String
  
  field :member_id, :type => String
  field :name, :type =>String
  
  field :instagram_image_url, :type => String
  field :instagram_media_id, :type => String
  field :tweet_id, :type => String
  field :tweet_image_url, :type => String
  
  field :location, :type => Array
  
  field :disease_type, :type => String, :default=>""
  
  field :occupation, :type => String, :default=>""
  field :gender, :type => String, :default=>""
  
  field :time, :type => Time, :default => lambda{ Time.now.utc }
  field :admit_time, :type => Date
  field :patient_birthday, :type => Date
  
  index [[ :post_group_id, Mongo::DESCENDING ]]
  index [[ "tweet_id", Mongo::DESCENDING ]]
  index [[ "instagram_media_id", Mongo::DESCENDING ]]
  index [[ :location, Mongo::GEO2D ], [ :time, Mongo::DESCENDING ]]
  
  before_create :rounding
  before_save :update_image, :update_to_group
  after_create :add_score
  after_destroy :delete_group, :remove_score
  
  alias_method :original_member_vote, :member_vote
  def member_vote(member, vote_type)
    
    ok, previous_value = original_member_vote(member, vote_type)
    
    if ok
      group = PostGroup.first(:conditions=>{:id=>self.post_group_id})
      group.update_itself if group
    end
    
  end
  

  def is_modification_allowed(member)
    return (member.is_admin == true or \
            (member.id == self.member_id and (Time.now - self.time) < 86400))
  end
 
  
  def get_image
    if self.instagram_image_url
      return self.instagram_image_url
    elsif self.tweet_image_url
      return self.tweet_image_url
    else
      return "http://#{DOMAIN_NAME}#{self.image}"
    end
  end
  
  
  def has_image?
    return (self.instagram_image_url != nil \
            or self.tweet_image_url != nil \
            or (self.image != "" and self.image != nil))
  end
  
  
  def votable?
    #return ((Time.now.utc - self.time.utc) < (3*3600))
    return false
  end

  def member
    return (Member.first(:conditions=>{:id=>self.member_id}) || Guest.new)
  end
  
  def get_patient_age
    now = Time.now.utc.to_date
    now.year - self.patient_birthday.year - ((now.month > self.patient_birthday.month || (now.month == self.patient_birthday.month && self.patient_birthday.day >= self.patient_birthday.day)) ? 0 : 1)
  end

  private
  def add_score
    if self.has_image?
      update_member_score(Post::SCORE_UPLOAD_PIC)
      ScorePerDay.update_member(self.member_id, Post::SCORE_UPLOAD_PIC, self.location, self.time)
    else
      update_member_score(Post::SCORE_NOPIC)
      ScorePerDay.update_member(self.member_id, Post::SCORE_NOPIC, self.location, self.time)
    end
  end


  def remove_score
    
    return if !self.member_id
    if self.has_image?
      update_member_score(-Post::SCORE_UPLOAD_PIC)
      ScorePerDay.update_member(self.member_id, -Post::SCORE_UPLOAD_PIC, self.location, self.time)
    else
      update_member_score(-Post::SCORE_NOPIC)
      ScorePerDay.update_member(self.member_id, -Post::SCORE_NOPIC, self.location, self.time)
    end
  end


  def update_member_score(score)
    
    member = Member.first(:conditions=>{:id=>self.member_id})
    return if !member
    
    member.inc(:all_score, score)
    
  end


  def rounding
    self.location[0] = self.location[0].round(4)
    self.location[1] = self.location[1].round(4)
  end
  
  
  def delete_group
    
    Mongoid.database.command({:getlasterror => 1})
    
    posts = Post.where(:post_group_id=>self.post_group_id).desc(:time).limit(2)
    
    group = PostGroup.first(:conditions=>{:id=>self.post_group_id})
    if group
      
      if posts.length == 0
        group.destroy
      else
        group.update_itself()
      end
      
    end
    
  end
  
  def update_to_group
    
    if self.post_group_id == nil
      lat = PostGroup.sanitize_location_unit(self.location[0])
      lng = PostGroup.sanitize_location_unit(self.location[1])
      
      group = PostGroup.first(:conditions=>{:location=>[lat,lng]})
      
      if !group
        
        while true
          group = PostGroup.create(:disease_type=>self.disease_type,
                                    :location=>[lat,lng])
          last_error = Mongoid.database.command({:getlasterror => 1})
            
          break if last_error['code'].to_i != 11000
          
          sleep(0.05)
        end

      else
        group.update_itself(self)
      end
  
      self.post_group_id = group.id
    else
      group = PostGroup.find(self.post_group_id)
      group.update_itself(self)
    end
    
  end
  
  def update_image
    return if !self.image_changed?
    
    if self.image_was != nil and self.image_was != ""
      FileUtils.remove(self.image_was, :force=>true)
    end
    
    return if self.image == nil
    return if self.image == ""
    
    basename = File.basename(self.image)
    new_image_path = "/uploads/#{basename}"
    
    FileUtils.move(File.join(Rails.root, "public", CGI.unescape(self.image)), 
                      File.join(Rails.root, "public", CGI.unescape(new_image_path)))
                      
    self.image = new_image_path
  end
  
  
  

end