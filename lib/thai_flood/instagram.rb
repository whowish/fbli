# encoding: utf-8

require File.expand_path("../abstract", __FILE__)

module ThaiFlood
  
  class Instagram
    
    CLIENT_ID = "cfab40c8c8414b03a4edd9e8801c42f2"
    
    class << self
    
      def initialize_resource
        
        @data = {
                  :client_id => CLIENT_ID
                }
        
        @base_url  = "https://api.instagram.com/v1/tags/gamling/media/recent"
        @url = "#{@base_url}?#{ThaiFlood.hash_to_query_string(@data)}"
       
      end
      
      
      def query

        #puts @url
        json = ThaiFlood.get_json(@url)
        
        #puts json['pagination'].inspect
        
        if ThaiFlood.key_exists(json, "pagination", "next_url")
          @url = json['pagination']['next_url']
        else
          @data[:min_tag_id] = (json['pagination']['next_min_id'] || @data[:min_tag_id])
          @url = "#{@base_url}?#{ThaiFlood.hash_to_query_string(@data)}"
        end

        return json['data']
        
      end
      
      
      def process(unit)
        
        return if !ThaiFlood.key_exists(unit, "location", "latitude") or !ThaiFlood.key_exists(unit, "location", "longitude")
        return if !ThaiFlood.key_exists(unit, "caption", "text")
        return if !ThaiFlood.key_exists(unit, "id")
        return if !ThaiFlood.key_exists(unit, "user", "id")
        return if !ThaiFlood.key_exists(unit, "images", "low_resolution", "url")
        return if !ThaiFlood.key_exists(unit, "user", "username")
        
        water_height = (ThaiFlood.get_water_height(unit['caption']['text']) || Post::WATER_LEVELS[0])
        
        checked = CheckedInstagram.first(:conditions=>{:instagram_media_id=>unit["id"]})
        
        if !checked
          
          
          
          member = InstagramMember.first(:conditions=>{:instagram_user_id => unit['user']['id']})
          
          if !member
            member = InstagramMember.create(:instagram_user_id => unit['user']['id'],
                                            :name => unit['user']['username']
                                            )
          end
          
          post = Post.create(:location=>[unit["location"]["latitude"], unit["location"]["longitude"]],
                              :image=>"",
                              :message=> unit['caption']['text'],
                              :place=> (unit['location']['name'] || ""),
                              :water_height=> water_height,
                              :instagram_media_id => unit['id'],
                              :instagram_image_url => unit['images']['low_resolution']['url'],
                              :member_id => member.id,
                              :name => member.name,
                              :time=>Time.at(unit['created_time'].to_i).utc
                            )
                            
                            
          CheckedInstagram.create(:instagram_media_id=>unit["id"])
          
        end
  
      end


    
    end

  end
  
end