module TwitterImageUrlResolver
  class Base
    
    class << self
      def match(url)
        raise 'Unimplemented'
      end
      
      def solve(url)
        raise 'Unimplemented'
      end
    end
    
  end
end