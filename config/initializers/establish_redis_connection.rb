require 'redis'
redis = RedisConnection.connection

# I have set application name for the time being, the keys and value can be changed later.
redis.set :application_name, 'Submify'
