class Link < ActiveRecord::Base
  attr_accessible :url_link,:url_heading
  has_and_belongs_to_many :users
  default_scope order: 'links.created_at DESC'
end
