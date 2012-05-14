module ThaiFlood
  
  class Abstract
    class << self
      
      def initialize_resource
        raise "Unimplemented"
      end
      
      def query
        raise "Unimplemented"
      end
      
      def process(row)
        raise "Unimplemented"
      end
      
    end
  end
end