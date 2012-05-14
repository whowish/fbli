module TwitterImageUrlResolver
  
  class Lockerz < Base
    
    class << self
     
      def match(url)
        return ((url.match("plixi") != nil)\
                or (url.match("lockerz") != nil))
      end
      
      def solve(url)
        return "http://api.plixi.com/api/tpapi.svc/imagefromurl?url=#{CGI.escape(url)}&size=mobile"  
      end
    
    end
    
  end
  
end