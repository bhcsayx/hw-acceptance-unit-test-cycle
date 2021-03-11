class Movie < ActiveRecord::Base

	def self.find_similar director
		Movie.where(:director => director)
	end
end
