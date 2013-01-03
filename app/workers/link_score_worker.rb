class LinkScoreWorker
  include Sidekiq::Worker
  #sidekiq_options queue: "high"
  sidekiq_options retry: false
  C = 45000

  def perform(link_user_id, vote_id)
    link_user = LinkUser.find(link_user_id)
    score = link_user.created_at.to_i #time is the default score 
    x = link_user.votes.count - link_user.downvotes.count 
    if x< 0 
      score =  score + ( C* x)
    elsif x>=1
      score = (C * Math::log10(x+1) ) +  score #-> this is reddit algorithm
    end
    link_user.update_column(:score, score)
    Notification.create!(notifiable_id: vote_id, notifiable_type: "Vote", user_id: link_user.user.id)
  end
end
