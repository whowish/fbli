set :stages, %w(staging production)
set :default_stage, "staging"

set :domain, "72.26.225.10"
require 'capistrano/ext/multistage'

set :application, "fbli"
set :repository,  "git@github.com:whowish/fbli.git"

set :use_sudo,    false
set :scm,         "git"
set :git_enable_submodules,1

set :user, "deploy"


role :app, domain
role :web, domain
role :db,  domain, :primary => true

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   
   desc "Restart Rails app"
   task :restart, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
 end
 
set :shared_assets, ['public/uploads','tmp']

namespace :assets  do
  namespace :symlinks do

    desc "Link assets for current deploy to the shared location"
    task :update, :roles => [:app, :web] do
      shared_assets.each { |link|
        begin 
          run "mkdir -p #{shared_path}/#{link} && chmod 777 #{release_path}/#{link}" 
        rescue
        end

        run "rm -rf #{release_path}/#{link}" 
        run "chmod 777 #{shared_path}/#{link} && ln -s #{shared_path}/#{link} #{release_path}/#{link}" 

      }
    end
  end
end

namespace :resque do
  desc "Start resque"
  task :start_workers, :roles => [:app, :web] do
    run "cd #{current_path} && bundle exec rake resque:start_workers RAILS_ENV=#{rails_env} --trace"
  end
  
  desc "Stop resque"
  task :stop_workers, :roles => [:app, :web] do
    run "cd #{current_path} && bundle exec rake resque:stop_workers RAILS_ENV=#{rails_env} --trace"
  end

end

namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, 'vendor/bundle')
    run("mkdir -p #{shared_dir} && ln -nfs #{shared_dir} #{release_dir}")
  end
 
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    shared_dir = File.join(shared_path, 'bundle')
    run "cd #{release_path} && bundle install --path vendor/bundle"
  end
end


before "deploy" do 
  resque.stop_workers
end

after "deploy:update_code" do
  bundler.bundle_new_release
end

after "deploy:symlink" do
  assets.symlinks.update
end

after "deploy" do 
  resque.start_workers
end




 

