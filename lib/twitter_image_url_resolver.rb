Dir[File.expand_path("../twitter_image_url_resolver", __FILE__)].each {|f| require f}

module TwitterImageUrlResolver
  
  RESOLVERS = [YFrog, Twitgoo, Lockerz]
  
  def resolve(url)
    RESOLVERS.each { |resolver|
      next if resolver.match(url) != true
      
      return resolver.solve(url)
      
    }
    
    return nil
  end
  
  extend self
  
end