if Rails.env.production?
$redis = Redis.new(:host => 'ec2-50-17-104-118.compute-1.amazonaws.com', :port => 6379)
elsif Rails.env.development?
$redis = Redis.new(:host => 'localhost', port: 6379)
end
