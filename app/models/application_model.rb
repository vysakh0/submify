class ApplicationModel < ActiveRecord::Base
  # attr_accessible :title, :body
  self.abstract_class = true


  def self.match_from_soulmate(term, klass_name)
  	matches = Soulmate::Matcher.new(klass_name).matches_for_term(term)
    matches.collect {|match| {"id" => match["id"], "label" => match["term"], 
    	"value" => match["term"], "url"  => match["data"]["url"], "imgsrc" => match["data"]["imgsrc"], "category" => "user"} }
  end
end
