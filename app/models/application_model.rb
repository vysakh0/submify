class ApplicationModel < ActiveRecord::Base
  # attr_accessible :title, :body
  self.abstract_class = true


  # ********************** # 
  # 	Class Methods 	     #
  # ********************** #	

  def self.match_from_soulmate(match_term, klass_name)
  	matches = SoulmateSubmify::CustomSoulmate.new_soulmate_matcher(klass_name).matches_for_term(match_term)

    matches.collect {|match| {"id" => match["id"], "label" => match["term"], 
    	"value" => match["term"], "url"  => match["data"]["url"], "imgsrc" => match["data"]["imgsrc"], "category" => klass_name} }
  end

  # ********************** # 
  # 	Instance Methods     #
  # ********************** #	

  def do_soulmate_by_operation(load_term, operation)
      loader = SoulmateSubmify::CustomSoulmate.new_soulmate_loader load_term
      if operation == :add
        loader.add("term" => name, "id" => id,"data" => { "url" => "/#{load_term}s/#{slug}", "imgsrc" => avatar.url(:thumb) } )
      else
        loader.remove("term" => name, "id" => id,"data" => { "url" => "/#{load_term}s/#{slug}", "imgsrc" => avatar.url(:thumb) } )
      end
  end
end
