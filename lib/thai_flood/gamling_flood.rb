# encoding: utf-8
require File.expand_path("../abstract", __FILE__)
require 'oauth'

MOBY_PICTURE_DEVELOPER_KEY = "GpXvD0QNxTzaa5lP"

module ThaiFlood
  
  class GamlingFlood < Abstract
    
    NUM_TWEETS = 200
    
    class << self
      
      def initialize_resource
        @since_id = nil
      end
      

      def query

        results = []

        data = { :count => 200,
                  :page => 1,
                  :include_entities  => 1,
                  :since_id => @since_id
                }

        base_url = "https://api.twitter.com/1/statuses/mentions.json"


        #while true

          url = "#{base_url}?#{hash_to_query(data)}"
          Rails.logger.info { "Fetch #{url}" }
          
          json = get_json(url)

          results += json
          
          json.each { |row|
            Rails.logger.info { "Got #{row['id_str']}" }
          }

          #data[:max_id] = (json.last['id']-1)
        #end
        if results.length > 0
          @since_id = results[0]['id']
        end

        return results

      end


      def process(tweet)

        return if !ThaiFlood.key_exists(tweet, "geo")
        return if !ThaiFlood.key_exists(tweet, "user", "screen_name")
        
        username = tweet['user']['screen_name']
         
        water_height = (ThaiFlood.get_water_height(tweet['text']) || Post::WATER_LEVELS[0])
         
        image_url = nil
        if ThaiFlood.key_exists(tweet, "entities", "urls")
          url = tweet['entities']['urls'][0]

          if ThaiFlood.key_exists(url, "expanded_url")
            
            if url['expanded_url'] != nil
              image_url = TwitterImageUrlResolver.resolve(url['expanded_url'])
              
              if image_url != nil
                tweet['text'] = tweet['text'].sub(url['url'], "")
              end
            end
          end
        end

        checked = CheckedTwitter.first(:conditions=>{:tweet_id => tweet['id_str']})
        
        if !checked
          
          
          member = TwitterMember.first(:conditions=>{:twitter_id=>username})
          
          if !member
            member = TwitterMember.create(:twitter_id => username,
                                          :name => "@#{username}")
          end
          
          post = Post.create(:location => [tweet["geo"]["coordinates"][0],tweet["geo"]["coordinates"][1]],
                              :image => "",
                              :message => tweet['text'],
                              :place => "",
                              :water_height=> water_height,
                              :tweet_id => tweet['id_str'],
                              :tweet_image_url => image_url,
                              :member_id => member.id,
                              :name => member.name,
                              :time=>Time.parse(tweet['created_at'])
                            )
                            
          CheckedTwitter.create(:tweet_id => tweet['id_str'])
          
        else
          #puts "Already exists"
        end
        
      end
      
      private
      def get_json(url)
        response = access_token.request(:get, url)
        return ActiveSupport::JSON.decode(response.body)
      end
      
      def access_token
        consumer = OAuth::Consumer.new("ftDzhqedZBQVJHSHgMjw", 
                                        "eDAafgTM014TCz1WhNzCOwXqNckiCY1FYFZdkdT7mHc",
                                        { :site => "https://api.twitter.com",
                                          :scheme => :header
                                          })
      
          token_hash = { :oauth_token => "196770516-cCEsPJIscsVRoss479RmeZbYt8Cnz5EtqwcimpAp",
                         :oauth_token_secret => "NJjLjobM0YVwQYWJnGfhRLRVmkeEEIMtvgGK8je3Y"
                       }
      
          access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
      
          return access_token
      end
      
      def hash_to_query(hash)
        query = []
        hash.each_pair { |key,value|
          next if value == nil
          query.push("#{key}=#{CGI.escape(value.to_s)}")
        }
        
        return query.join("&")
      end

    end
  
  end
  
end