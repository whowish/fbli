module TwitterImageUrlResolver
  
  class YFrog < Base
    
    class << self
      
      def match(url)
        return (url.match("yfrog") != nil)
      end
      
      def solve(url)
        return "#{url}:iphone"  
      end
      
    end
    
  end
  
end