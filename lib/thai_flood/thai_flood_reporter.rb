# encoding: utf-8

require File.expand_path("../abstract", __FILE__)

module ThaiFlood
  
  class ThaiFloodReporter < Abstract
    
    NUM_TWEETS = 100
    
    class << self
      
      def initialize_resource
        
        @data = { :q => "#thaiflood maps.google",
                 :result_type => "recent",
                 :with_twitter_user_id => "false",
                 :include_entities => "true",
                 :rpp => NUM_TWEETS
                }
                
        @query = []
        @data.each_pair { |key,value|
          @query.push("#{key}=#{CGI.escape(value.to_s)}")
        }
        
        @base_url = "http://search.twitter.com/search.json"
        @url = "#{@base_url}?#{@query.join("&")}"
        
      end
      

      def query
        json = ThaiFlood.get_json(@url)
      
        if json['refresh_url']
          @url = "#{@base_url}#{json['refresh_url']}" 
        else
          @url = "#{@base_url}?#{@query.join("&")}"
        end
        
        return json['results']
      end
      
      
      def process(tweet)
        
        checked = CheckedTwitter.first(:conditions=>{:tweet_id => tweet['id_str']})
        return if checked
 
        map_url = get_redirect_url(tweet['entities']['urls'][0]['expanded_url'])
        parsed_url = URI.parse(map_url)
        params = CGI.parse(parsed_url.query)
        return if !(params['q'] and params['q'][0])
        
        location = params['q'][0].split(',').map { |i| i.to_f}

        water_height_text = get_water_text(tweet['text'])
          
        
        member = TwitterMember.first(:conditions=>{:twitter_id=>tweet['from_user']})
        
        if !member
          member = TwitterMember.create(:twitter_id => tweet['from_user'],
                                        :name => "@#{tweet['from_user']}")
        end
        
        post = Post.create(:location=> location,
                            :image=>"",
                            :message=> water_height_text,
                            :place=> get_place(tweet['text']),
                            :water_height=> (ThaiFlood.get_water_height(water_height_text) || Post::WATER_LEVELS[0]),
                            :tweet_id => tweet['id_str'],
                            :member_id => member.id,
                            :name => member.name,
                            :time=>Time.parse(tweet['created_at'])
                          )
                          
        CheckedTwitter.create(:tweet_id => tweet['id_str'])
        
        
      rescue Exception => e
        Rails.logger.error { "#{e.message}" }
      end
      
      
      def get_place(tweet)
        
        result = tweet.match(/\[[^\]]+\] *([^ ]+) +([^ ]+)/i)
        
        raise "Cannot find place" if !result[1]
        
        if result.length >= 3
          return "#{result[1]} #{result[2]}"
        else
          return "#{result[1]}"
        end
        
      end
      
      
      def get_water_text(tweet)
        
        result = tweet.match(/"([^"]+)" #thaiflood/i)
        
        raise "Cannot find water_text" if !result[1]
        
        return result[1]
        
      end
      
      
      def get_redirect_url(url)
        
        url = URI.parse(url)
        req = Net::HTTP::Get.new("#{url.path}?#{url.query}")
        res = Net::HTTP.start(url.host, url.port) {|http|
          http.request(req)
        }
        
        return res.header['location'] if res.header['location']
        return nil
        
      end
    end
  
  end
  
end