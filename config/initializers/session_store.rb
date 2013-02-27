# Be sure to restart your server when you modify this file.
#Submify::Application.config.session_store :redis_session_store,
#:db => 0,
#:expire_after => 10.minutes,
#:key_prefix => "youarel:session:"

if Rails.env.production?
  Submify::Application.config.session_store :redis_store, servers: { host: 'ec2-50-17-104-118.compute-1.amazonaws.com', port: 6379 }
else

  Submify::Application.config.session_store :redis_store, servers: { host: 'localhost', port: 6379 }
end
#Submify::Application.config.session_store :cookie_store, key: '_youarel_session'
#Rails.application.config.session_store ActionDispatch::Session::CacheStore, :expire_after => 20.minutes
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
#Submify::Application.config.session_store :redis_store,
#servers: { host: 'localhost', port: 6379},
#key_prefix: "Submify:rails:session",
#expire_in: 20.minutes

