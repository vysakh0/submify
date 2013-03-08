module SoulmateSubmify

	class CustomSoulmate

		# ********************** # 
		# 	Class Methods 	     #
		# ********************** #	

		def self.new_soulmate_loader(load_term)
			begin
			      Soulmate::Loader.new(load_term)
			rescue Errno::ECONNREFUSED
			      Rails.logger.warn "Cannot contact Redis: #{$!}"
			end
			
		end	

		def self.new_soulmate_matcher(klass_name)
			Soulmate::Matcher.new(klass_name)
		end
	end
		
end