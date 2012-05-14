module TwitterImageUrlResolver
  
  class Twitgoo < Base
    
    class << self
      
      def match(url)
        return (url.match("twitgoo") != nil)
      end
      
      def solve(url)
        return "#{url}/img"  
      end
      
    end
    
  end
  
end