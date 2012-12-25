class Topic < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessible :description, :name, :avatar
  has_attached_file :avatar, styles: { medium: "200x200>", thumb: "100x100>"}, default_style: :thumb, default_url:'/images/avatar/missing_topic_thumb.png'
  has_many :link_users, foreign_key: "topic_id", dependent: :destroy
  has_many :links, through: :link_users, source: :link

  has_many :topic_user_relationships, foreign_key: "topic_id", dependent: :destroy

  has_many :following_users, through: :topic_user_relationships, source: :user
  after_save :load_into_soulmate

  before_destroy :remove_from_soulmate
  after_update :flush_name_cache

  def topic_name
    Rails.cache.fetch([:topic, id, :name]) do
      name
    end
  end

  def flush_name_cache
    Rails.cache.delete([:topic, id, :name]) if name_changed?
  end


  def remove_from_soulmate
    loader = Soulmate::Loader.new("topic")
    loader.remove("term" => name, "id" => id,"data" => { "url" => "/topics/#{slug}", "imgsrc" => avatar.url(:thumb) } )
  end
  def load_into_soulmate
    loader = Soulmate::Loader.new("topic")
    loader.add("term" => name, "id" => id,"data" => { "url" => "/topics/#{slug}", "imgsrc" => avatar.url(:thumb) } )
  end

  def self.search(term)
    matches = Soulmate::Matcher.new('topic').matches_for_term(term)
    matches.collect {|match| {"id" => match["id"], "label" => match["term"], "value" => match["term"], "url"  => match["data"]["url"], "imgsrc" => match["data"]["imgsrc"] , "category" => "topic"} }
  end

  def topic_feed
    Link.feed_topic(self.id)

  end

end
