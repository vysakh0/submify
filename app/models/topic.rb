class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :description, :name, :id

  has_many :link_users, foreign_key: "topic_id", dependent: :destroy
  has_many :links, through: :link_users, source: :link

  after_save :load_into_soulmate

  def load_into_soulmate
    loader = Soulmate::Loader.new("topic")
    loader.add("term" => name, "id" => id)
  end
  def self.search(term)
    matches = Soulmate::Matcher.new('topic').matches_for_term(term)
    matches.collect {|match| {"id" => match["id"], "label" => match["term"], "value" => match["term"] } }
  end

end
