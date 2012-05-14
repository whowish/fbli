# Resque tasks
require 'daemon_spawn'
require File.expand_path("../../thai_flood", __FILE__)


class ThaiFloodDaemon < DaemonSpawn::Base
  def start(args)
    ThaiFlood.run
  end

  def stop
    ThaiFlood.stop
  end
end


namespace :thai_flood do
  
  
  task :run => :environment  do
    ThaiFlood.run
  end
  
  task :start => :environment do
    
   raise 'thaiflood.pid exists. Please erase it first and run again.' \
            if File.exist?(File.join(Rails.root,"tmp/pids/thaiflood.pid"))
    
    puts "Starting pulling data from Twitter #Thaiflood"
 
    ThaiFloodDaemon.spawn!({
      :log_file => File.join(Rails.root.to_s, "log", "thaiflood.log"),
      :pid_file => File.join(Rails.root.to_s, 'tmp', 'thaiflood.pid'),
      :sync_log => true,
      :working_dir => Rails.root.to_s,
      :singleton => true
    },["start"])
    
  end
  
  task :stop => :environment do
    
    ThaiFloodDaemon.spawn!({
      :log_file => File.join(Rails.root.to_s, "log", "thaiflood.log"),
      :pid_file => File.join(Rails.root.to_s, 'tmp', 'thaiflood.pid'),
      :sync_log => true,
      :working_dir => Rails.root.to_s,
      :singleton => true
    },["stop"])

  end
  
end