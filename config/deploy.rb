require "rvm/capistrano" 
require "bundler/capistrano"

server "184.72.240.67", :web, :app

set :application, "youarel"
set :user, "ubuntu"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :rvm_type, :system

set :scm, "git"
set :repository, "git@bitbucket.org:vysakh0/submify.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
before 'deploy:setup', 'rvm:install_rvm'
set :rvm_install_type, :stable
set :rvm_install_pkgs, %w[libyaml openssl]
set :rvm_install_ruby_params, '--with-opt-dir=~/.rvm/usr'  # or for system installs:
# set :rvm_install_ruby_params, '--with-opt-dir=/usr/local/rvm/usr'
before 'deploy:setup', 'rvm:install_pkgs'

before 'deploy:setup', 'rvm:install_ruby-1.9.3-p327'
before 'deploy:setup', 'rvm:import_gemset'
before 'deploy:setup', 'rvm:export_gemset'
after "deploy", "deploy:cleanup" # keep only the last 5 releases


namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end
