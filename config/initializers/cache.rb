# require 'dalli'
# 
# #CACHE = Dalli::Client.new('127.0.0.1:11211')
# #CACHE.set("test","test")
# 
# if defined?(PhusionPassenger)
  # PhusionPassenger.on_event(:starting_worker_process) do |forked|
    # # Reset Rails's object cache
    # # Only works with DalliStore
    # Rails.cache.reset if forked
# 
    # # Reset Rails's session store
    # # If you know a cleaner way to find the session store instance, please let me know
    # # ObjectSpace.each_object(ActionDispatch::Session::DalliStore) { |obj| obj.reset }
  # end
# end

