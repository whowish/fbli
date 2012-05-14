require 'resque'
require 'yaml'

yml = YAML.load_file File.expand_path("../../redis.yml",__FILE__)
config = yml[Rails.env.to_s.downcase]

Resque.redis = Redis.new(:host => config['host'], :port => config['port'])

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    Rails.logger.info { "Passenger forked"}
    if forked
      Rails.logger.info { "Reconnected" }
      Resque.redis = Redis.new(:host => config['host'], :port => config['port'])
    end
  end
end
