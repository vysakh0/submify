class LinkScoreWorker
  include Sidekiq::Worker
  #sidekiq_options queue: "high"
   sidekiq_options retry: false
  C = 45000
  EPOCH = 1356264052 #time in milli seconds 23rd dec 5.31 PM
  
  def perform(link_user_id)
    link_user = LinkUser.find_by_id(link_user_id)
    t1= link_user.created_at.to_i - link_user.link.created_at.to_i
      #time between link creation and link_user creation, so that first person has more points than the second, also check second does not take advantage of first votes

    t = (link_user.created_at.to_i - EPOCH)
    x = link_user.link.votes.count + (link_user.comments.count/2)  - link_user.downvotes.count 
    z = x
    z = 1 if x <= 0
    y = 0
    if x< 0 
      y= -1
    elsif x>=1
      y= 1
    end
    score = (C * Math::log10(z) ) +  (t * y) - t1 #-> this is reddit algorithm
    link_user.update_column(:score, score)
  end
end
