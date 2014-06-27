require "bundler/capistrano"
# for multiple enviroments
require 'capistrano/ext/multistage'

set :repository,  "git@github.com:jatin-baweja/spree_loyalty_points_demo.git"
set :stages, %w(staging)
set :scm, :git

default_run_options[:pty] = true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Deploy with migrations"
  task :long do
    transaction do
      update_code
      web.disable
      create_symlink
      migrate
    end

    restart
    web.enable
    cleanup
  end

  
  task :after_symlink, :roles => :app do
    run "ln -s #{ shared_path }/database.yml #{current_path}/config/database.yml"
    run "ln -s #{ shared_path }/spree #{current_path}/public/"
  end

  desc "Run cleanup after long_deploy"
  task :after_deploy do
    cleanup
  end

  task :precompile_assets do
    run "cd #{current_path} ; RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end

end

task :tail_log, :roles => :app do 
  sudo "tail -f #{shared_path}/log/#{rails_env}.log" 
end 

after "deploy:create_symlink", "deploy:after_symlink"
after "deploy:after_symlink", "deploy:precompile_assets"
        require './config/boot'
