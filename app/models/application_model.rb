class ApplicationModel < ActiveRecord::Base
  # attr_accessible :title, :body
  self.abstract_class = true


  # ********************** # 
  # 	Class Methods 	   #
  # ********************** #	

  def self.match_from_soulmate(match_term, klass_name)
  	matches = Soulmate::Matcher.new(klass_name).matches_for_term(match_term)

    matches.collect {|match| {"id" => match["id"], "label" => match["term"], 
    	"value" => match["term"], "url"  => match["data"]["url"], "imgsrc" => match["data"]["imgsrc"], "category" => "user"} }
  end

  # ********************** # 
  # 	Instance Methods   #
  # ********************** #	

  def remove_from_soulmate(load_term)
  	loader = Soulmate::Loader.new(load_term)
  	loader.remove("term" => name, "id" => id,"data" => { "url" => "/#{load_term}s/#{slug}", "imgsrc" => avatar.url(:thumb) } )
  end

  def load_into_soulmate(load_term)
    loader = Soulmate::Loader.new(load_term)
    puts "----loader: #{loader.inspect}----#{name}----#{id}------#{avatar.url(:thumb).inspect}"
    loader.add("term" => name, "id" => id,"data" => { "url" => "/#{load_term}s/#{slug}", "imgsrc" => avatar.url(:thumb) } )
  end


end
