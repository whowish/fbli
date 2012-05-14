# encoding: utf-8
require 'net/http'
require 'net/https'
require 'uri'
require 'cgi'
require 'active_support/json'

require File.expand_path("../thai_flood/thai_flood_reporter", __FILE__)
require File.expand_path("../thai_flood/gamling_flood", __FILE__)
require File.expand_path("../thai_flood/instagram", __FILE__)

module ThaiFlood
  

  WAIT_SUCCESS = 60 * 3
  WAIT_ERROR = 60
  
  if Rails.env == "development"
    SERVICES = [GamlingFlood]
  else
    SERVICES = [ThaiFloodReporter, Instagram, GamlingFlood]
  end
  
  def run
    
    @is_running = true
    
    SERVICES.each { |s| s.initialize_resource }

    while @is_running

        ok = true
        
        SERVICES.each { |s| 
        
          begin
            
            data = s.query 
            
            data.each { |row|
            
              begin
                s.process(row)
                Mongoid.database.command({:getlasterror => 1}) # make sure it is commited
              rescue Exception => e   
                Rails.logger.warn { "#{e.message}\n#{e.backtrace.join("\n")}" }
              end
              
              break if !@is_running
            }
            
          rescue Exception => e   
            Rails.logger.warn { "#{e.message}\n#{e.backtrace.join("\n")}" }
          end

            
            break if !@is_running
        }
        
        if ok
          wait(WAIT_SUCCESS)
        else
          wait(WAIT_ERROR)
        end
        
      
      
    end
    
  end
  
  def stop
    @is_running = false
  end
  

  def wait(seconds)
    puts "wait #{seconds}"
    seconds.times {
      sleep(1)
      break if !@is_running
    }
    
  end
  
  
  def get_json(url)
   
    url = URI.parse(url)
    http = Net::HTTP.new(url.host,url.port)
    
    if url.scheme == "https"
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  
    response = http.get("#{url.path}?#{url.query}")
    
    return ActiveSupport::JSON.decode(response.body)
    
  end
  
  
  def get_water_height(text)
        
        translation = [ ["ไม่ท่วม", Post::WATER_LEVELS[0]],
                        ["ไมท่วม", Post::WATER_LEVELS[0]],
                        ["ปรกติ", Post::WATER_LEVELS[0]],
                        ["ปกติ", Post::WATER_LEVELS[0]],
                        ["เข้าสู่ภาวะปกติ", Post::WATER_LEVELS[0]],
                        ["ไม่น่าเป็นห่วง", Post::WATER_LEVELS[0]],
                        ["แห้ง", Post::WATER_LEVELS[0]],
                        
                        ["น้ำท่วม", Post::WATER_LEVELS[1]],
                        ["เล็กน้อย", Post::WATER_LEVELS[1]],
                        ["เกาะกลางถนน", Post::WATER_LEVELS[1]],
                        ["ข้อเท้า", Post::WATER_LEVELS[1]],
                        ["ฟุตบาท", Post::WATER_LEVELS[1]],
                        
                        ["รถยังวิ่งได้", Post::WATER_LEVELS[2]],
                        ["ครึ่งแข้ง", Post::WATER_LEVELS[2]],
                        ["เข่า", Post::WATER_LEVELS[2]],
                        
                        ["ห้ามรถเล็ก", Post::WATER_LEVELS[3]],
                        ["ปิดถนน", Post::WATER_LEVELS[3]],
                        ["เอว", Post::WATER_LEVELS[4]],
                        ["สูง", Post::WATER_LEVELS[4]],
                        ["หนึ่งเมตร", Post::WATER_LEVELS[4]],
                        ["อพยพ", Post::WATER_LEVELS[4]],
                        
                        ["เมตรกว่า", Post::WATER_LEVELS[4]],
                        ["ท่วมอก", Post::WATER_LEVELS[5]],
                        ["ถึงอก", Post::WATER_LEVELS[5]],
                        
                        ["ถึงคอ", Post::WATER_LEVELS[6]],
                        ["ท่วมคอ", Post::WATER_LEVELS[6]],
                        ["ล้นแนวกั้น", Post::WATER_LEVELS[6]],
                        
                        ["ถึงหัว", Post::WATER_LEVELS[7]],
                        ["ท่วมหัว", Post::WATER_LEVELS[7]],
                        ["สองเมตร", Post::WATER_LEVELS[7]]
                      ]
                      
        
        translation.reverse.each { |package|
          return package[1] if text.match(package[0])
        }
        
        return nil
        
  end
  
  def hash_to_query_string(hash)
    query = []
    hash.each_pair { |key,value|
      query.push("#{key}=#{CGI.escape(value.to_s)}")
    }
    
    return query.join("&")
  end
  
  def key_exists(hash, *keys)
    
    keys.each { |k|
      if hash != nil and hash.has_key?(k)
        hash = hash[k]
      else
        return false
      end
    }
    
    return (hash!=nil)
    
  end
  

  
  extend self
end