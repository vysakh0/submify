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

  belongs_to :link, class_name: "Link", touch: true
  belongs_to :user, class_name: "User", touch: true
  belongs_to :topic, class_name: "Topic", touch: true
  has_many :downvotes,as: :votable, dependent: :destroy

  default_scope order: 'link_users.created_at DESC'


  validates :link_id, presence: true



  after_save :add_downvote
  C = 45000
  EPOCH = 1356264052 #time in milli seconds 23rd dec 5.31 PM
  def calculate_score
        x = 0
        x = self.link.score if score
        self.score =  x - (C * 2)
  end
  def add_downvote
    vote =TopicDownvote.new(user_id: 0,topic_id: topic_id, link_id: link_id) 
    vote.save
  end
# add score: when it is newly created
# calculate: periodically based on the votes,downvotes,comments
# remove old link_users based on some algorithm
  def self.from_users_followed_by(user)
    followed_topic_ids = "SELECT topic_id FROM topic_user_relationships WHERE user_id = :user_id"
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("topic_id IN (#{followed_topic_ids}) OR  user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id).uniq
  end

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
