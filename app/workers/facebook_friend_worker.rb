class FacebookFriendWorker
  include Sidekiq::Worker
  sidekiq_options queue: "high"
  # sidekiq_options retry: false
  
  def perform(uid, oauth_token)
    user = User.find_by_uid(uid)
    new_user = FbGraph::User.fetch(uid, access_token: oauth_token)
    new_user.friends.each do |friend|
    if  existing_user = User.find_by_uid(friend.identifier)
      user.follow!(existing_user)
      existing_user.follow!(user)
    end
    end
  end
end
