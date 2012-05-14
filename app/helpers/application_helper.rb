# encoding: utf-8
require 'net/http'
module ApplicationHelper
  
  def semantic_water_height(height)
    
    if height < 100
      return "#{height} เซ็นติเมตร"
    end
    
    metres = (height / 100).to_i
    cm = height % 100
    
    if cm == 0
      return "#{metres} เมตร"
    else
      return "#{metres}.#{"%02d" % cm} เมตร"
    end
    
  end
  
  
  def get_address(lat, lng)
    
    url = URI.parse("http://maps.googleapis.com/maps/api/geocode/json?sensor=false&latlng=#{lat},#{lng}&language=th")
    path = (url.query.blank?) ? url.path : "#{url.path}?#{url.query}"
    
    req = Net::HTTP::Get.new(path)
    
    response = Net::HTTP.start(url.host, url.port) { |http|
      http.open_timeout = 10
      http.request(req)
    }
    
    json = ActiveSupport::JSON.decode(response.body)
    
    return json['results'][0]['address_components'][0]['long_name'];
    
  rescue Exception=>e
    Rails.logger.info {e.message}
    return ""
  end
  
  
  def generate_vote_function(member, post_id, vote_type)
    
    if member.is_guest
      redirect_url = "http://#{DOMAIN_NAME}/facebook/post/vote/#{post_id}/#{vote_type}"
      url = "https://www.facebook.com/dialog/oauth?client_id=#{APP_ID}&redirect_uri=#{CGI.escape(redirect_url)}"
      return "$(this).loading_button(true, {word:''});location.href='#{url}';"
    else
      return "view_handler.vote('#{post_id}', '#{vote_type}', this);"
    end
    
  end
end
