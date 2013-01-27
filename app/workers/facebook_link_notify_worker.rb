
class FacebookLinkNotifyWorker
  include Sidekiq::Worker
  #sidekiq_options queue: "high"
   sidekiq_options retry: false
  
  def perform(oauth_token, link)
    app = FbGraph::Application.new(FACEBOOK_CONFIG['app_id'])
    me = FbGraph::User.me(oauth_token)
    action = me.og_action!(
      app.og_action(:submit), # or simply "APP_NAMESPACE:ACTION" as String
      :link => link
    )
  end
end
