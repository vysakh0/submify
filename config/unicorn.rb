root = "/home/ubuntu/apps/blog/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.blog.sock"
worker_processes 6
timeout 30
after_fork do |server, worker|
  if defined?(Sidekiq)
    Sidekiq.configure_client do |config|
      config.redis = { :size => 1 }
    end
  end
end
