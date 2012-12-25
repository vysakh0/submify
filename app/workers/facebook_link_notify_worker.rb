
class FacebookLinkNotifyWorker
  include Sidekiq::Worker
  include SessionsHelper
  #sidekiq_options queue: "high"
   sidekiq_options retry: false
  
  def perform(link)
    app = FbGraph::Application.new("295241533825642")
    me = FbGraph::User.me(current_user.oauth_token)
    action = me.og_action!(
      app.og_action(:submit), # or simply "APP_NAMESPACE:ACTION" as String
      :website => link
    )
  end
end
