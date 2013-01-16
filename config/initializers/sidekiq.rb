Sidekiq.configure_server do |config|
  config.redis = Redis.new(:host => 'ec2-50-17-104-118.compute-1.amazonaws.com' , :port => 6379)
end
# Next, you need to configure the Sidekiq client, which is similar.
# If you're using the client with a single-threaded Rails (or other ruby) process,
# add a size of 1, which will provide one Redis connection for the client:

Sidekiq.configure_client do |config|
  config.redis = Redis.new(:host => 'ec2-50-17-104-118.compute-1.amazonaws.com' , :port => 6379)
end
