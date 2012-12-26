class CommentScoreWorker
  include Sidekiq::Worker
  #sidekiq_options queue: "high"
  sidekiq_options retry: false
  C = 45000
  EPOCH = 1356264052 #time in milli seconds 23rd dec 5.31 PM

  def perform(link_id)
    link = Link.find_by_id(link_id)
    link.comments.each do |comment|
      cal_score(comment)
    end
  end
  def cal_score(comment)
    t = (comment.created_at.to_i - EPOCH)
    x = comment.votes.count + (comment.comments.count/2) - comment.downvotes.count  #number of upvotes only
    if x <= 0
      score = t + (C * x)
      comment.update_column(:score, score)
    else
      score = (C * Math::log10(x + 1)) +  t
      comment.update_column(:score, score)
    end
  end
end