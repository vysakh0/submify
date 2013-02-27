class ApplicationModel < ActiveRecord::Base
  # attr_accessible :title, :body
  self.abstract_class = true
end
