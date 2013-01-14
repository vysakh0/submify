root = "/home/ubuntu/apps/youarel"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.youarel.sock"
worker_processes 7
timeout 30
