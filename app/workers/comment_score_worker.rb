class CommentScoreWorker
  include Sidekiq::Worker
  #sidekiq_options queue: "high"
  sidekiq_options retry: false
  C = 45000

  def perform(comment_id)
    comment = Comment.find_by_id(comment_id)
    x = comment.votes.count  - comment.downvotes.count  #number of upvotes only
    if x <= 0
      score =  x
    else
      score = (C * Math::log10(x + 1)) + comment.created_at.to_i 
    end
    comment.update_column(:score, score)

    Notification.create!(notifiable_id: notifable_id, notifiable_type: notifiable_type , user_id: link_user.user.id)
  end
end
