# This file is used by Rack-based servers to start the application.

require 'resque/server'

Resque::Server.use Rack::Auth::Basic do |username, password|
	username == 'tanin' && password == 'resque#4747'
end

require ::File.expand_path('../config/environment',  __FILE__)
run Rack::URLMap.new "/" => Fbli::Application, "/resque" => Resque::Server.new
