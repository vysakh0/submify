# == Schema Information
#
# Table name: link_users
#
#  id         :integer          not null, primary key
#  link_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LinkUser < ActiveRecord::Base

  attr_accessible :link_id, :user_id, :topic_id

  belongs_to :link, class_name: "Link"
  belongs_to :user, class_name: "User"
  belongs_to :topic, class_name: "Topic"

  default_scope order: 'link_users.created_at DESC'

  validates :link_id, presence: true

# add score: when it is newly created
# calculate: periodically based on the votes,downvotes,comments
# remove old link_users based on some algorithm

  def scored(score)
    if score > self.high_score
      $redis.zadd("highscores", score, self.id)
    end
  end

  # table rank
  def rank
    $redis.zrevrank("highscores", self.id) + 1
  end

  # high score
  def high_score
    $redis.zscore("highscores", self.id).to_i
  end

  # load top 3 users
  def self.top_links range
    $redis.zrevrange("highscores", 0, range).map{|id| User.find(id)}
  end

end
