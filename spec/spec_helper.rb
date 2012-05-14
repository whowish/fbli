# encoding: utf-8
require 'simplecov'
SimpleCov.start 'rails' do
  coverage_dir("coverage") 
end

require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  
  
  
  require File.expand_path("../../config/environment", __FILE__)
  
  require 'rspec/rails'
  require 'watir-webdriver-rails'
  
  WatirWebdriverRails.host = "localhost"
  WatirWebdriverRails.port = 57124

  require 'database_cleaner'
  require 'win32/process'
  require 'fileutils'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  
  
  RSpec.configure do |config|
    
    config.include Browser
    config.include MongoidHelper
    config.include ResqueHelper
    config.include DebuggerHelper
    config.include JsonRspecHelper
    config.include MemberRspecHelper
    config.include Mongoid::Matchers
    config.include ImageRspecHelper

    config.mock_with :rspec
    
   config.before(:suite) do
      
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.orm = "mongoid"
      
      DatabaseCleaner.clean
      
      all_files = Dir.glob(Rails.root.join('app', 'models', '*.rb'))
      all_models = all_files.map { |path| File.basename(path, '.rb').camelize.constantize }
      mongoid_models = all_models.select { |m| m.respond_to?(:create_indexes) }
      
      mongoid_models.each do |model|
  
        begin
          model.collection.drop_indexes
        rescue Exception
        end
        
        begin
          model.create_indexes
        rescue Exception=>e
          puts "Error while indexing #{model.name}"
          raise e
        end
      end
      
      FileUtils.mv(File.join(Rails.root, "public/uploads"), File.join(Rails.root, "public/uploads_development")) rescue ""
      FileUtils.mkdir_p File.join(Rails.root, "public/uploads") rescue ""
      
    end
    
    config.after(:suite) do
      
      FileUtils.remove_dir(File.join(Rails.root, "public/uploads_test")) rescue ""
      FileUtils.mv(File.join(Rails.root, "public/uploads"), File.join(Rails.root, "public/uploads_test")) rescue ""
      FileUtils.mv(File.join(Rails.root, "public/uploads_development"), File.join(Rails.root, "public/uploads")) rescue ""
      
    end

    config.before(:each) do
      
      ActionMailer::Base.deliveries = []
      DatabaseCleaner.clean
      $redis.flushall
      Mongoid.database.command({:getlasterror => 1,:fsync=>true})
      Rails.cache.clear
      
      ResqueSpec.reset!
      
      ActionMailer::Base.delivery_method = :test
      
      FileUtils.mkdir_p File.join(Rails.root, "public/uploads/temp")
      FileUtils.mkdir_p File.join(Rails.root, "public/uploads/images")
      
      Dir[File.join(Rails.root, "public/uploads/temp/*")].each { |f| 
        FileUtils.remove(f, :force=>true)
      }
      
      Dir[File.join(Rails.root, "public/uploads/images/*")].each { |f| 
        FileUtils.remove(f, :force=>true)
      }
      
    end
  
    config.after(:each) do

    end

    
    ActiveSupport::Dependencies.clear 
    
  end
  
end

Spork.each_run do

  load "#{Rails.root}/config/routes.rb"
  Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f } 
  
end


