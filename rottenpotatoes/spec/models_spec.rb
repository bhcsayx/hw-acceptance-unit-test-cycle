require 'rails_helper'

describe "Search movies having same director" do
		before(:all) do
			@mov1 = Movie.create!(:director => "Xiaogang Feng")
			@mov2 = Movie.create!(:director => "Kaige Chen")
			@mov3 = Movie.create!(:director => "")
			@mov4 = Movie.create!(:director => "Kaige Chen")
		end
		it 'should find movies with same director' do
			 expect(Movie.find_similar(@mov2[:director])).to include(@mov4)
			 expect(Movie.find_similar(@mov4[:director])).to include(@mov2)
		end

		it 'should not find movies with different director' do
			 expect(Movie.find_similar(@mov2[:director])).to_not include(@mov3)
			 expect(Movie.find_similar(@mov4[:director])).to_not include(@mov1)
		end

		it 'should not find anything given a movie with empty director' do
			expect(Movie.find_similar(@mov3[:director])).to_not include(@mov2)
			expect(Movie.find_similar(@mov3[:director])).to_not include(@mov1)
			expect(Movie.find_similar(@mov3[:director])).to_not include(@mov4)
		end

  end
