source 'http://rubygems.org'

gem 'rails'

gem 'log4r'
gem 'bson', '1.4.0'
gem 'bson_ext', '1.4.0'
gem 'mongo'
gem 'mongoid'
gem 'redis'
gem 'mongoid_rails_migrations'
gem 'bcrypt-ruby'

gem 'daemon-spawn-tanin'

gem 'rake','0.8.7'

gem 'capistrano'
gem 'capistrano-ext'

gem 'whowish_word', '0.3.1'

gem 'resque'

gem 'dalli', '1.1.2'
gem 'oauth'

group :development do
	gem 'capistrano'
end

platforms :mingw do
	group :test do
		
		gem 'rspec'
		gem 'rspec-rails'
		gem 'simplecov'
		
		gem 'database_cleaner'
		gem 'mongoid-rspec'
		gem 'resque_spec'
		
		gem 'watir-webdriver-rails'
		
		gem 'win32-process'
		gem 'spork', '~> 0.9.0.rc'
		
	end
	
	group :development, :test do
		gem 'linecache19', '0.5.11'
		gem 'ruby-debug19'
	end
end
