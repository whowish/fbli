# encoding: utf-8
module JsonRspecHelper
  
  def expect_json_response
    response.should be_success
    return ActiveSupport::JSON.decode(response.body)
  end
  
end

RSpec::Matchers.define :be_ok do |expected|
  match do |actual|
    
    if !actual.kind_of?(Hash) or actual.has_key?('ok') == false
      raise "Expect Hash with a key :ok. But got: #{actual.inspect}"
    end
    
    actual['ok']
    
  end
  
  failure_message_for_should do |actual|
    "Expect :ok to be true. Here is the actual response: #{actual.inspect}"
  end

  failure_message_for_should_not do |actual|
    "Expect :ok to be false. Here is the actual response: #{actual.inspect}"
  end

  description do
    "Verify JSON response"
  end
  
end

RSpec::Matchers.define :have_error do |*args|
  match do |actual|
    
    ret_value = false
    
    begin
      
      if args.length == 1
        
        ret_value = (actual['error_messages'] == args[0])
        
      elsif args.length >= 2
        
        ret_value = true
  
        args[1..-1].each_with_index { |msg, index|
          ret_value = ret_value && (actual['error_messages'][args[0].to_s][index] == msg)
        }
  
      else
        raise 'Wrong number of arguments: support only 1 or 2 arguments'
      end

    rescue Exception=>e
      raise "Exception raised from: #{actual.inspect}"
    end

    ret_value

  end
  
  failure_message_for_should do |actual|
    
    if args.length == 1
      
      "Expect an error string :error_messages=>'#{args[0]}'\nbut got: #{actual.inspect}"
      
    elsif args.length == 2
      
      "Expect an error string :error_messages=>{:#{args[0]}=>'#{args[1]}'}\nbut got: #{actual.inspect}"
      
    end

  end

  failure_message_for_should_not do |actual|
    
    if args.length == 1
      
      "Expect an error string to NOT match :error_messages=>'#{args[0]}'\nbut got: #{actual.inspect}"
      
    elsif args.length == 2
      
      "Expect an error string to NOT match :error_messages=>{:#{args[0]}=>'#{args[1]}'}\nbut got: #{actual.inspect}"
      
    end
    
  end

  description do
    "Verify error messages"
  end
  
end