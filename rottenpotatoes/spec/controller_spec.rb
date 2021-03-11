require 'rails_helper'
require 'spec_helper'

if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

describe MoviesController, :type => :controller do
	before(:all) do
			@mov1 = Movie.create!(:director => "Xiaogang Feng")
			@mov2 = Movie.create!(:director => "Kaige Chen")
			@mov3 = Movie.create!(:director => "")
			@mov4 = Movie.create!(:director => "Kaige Chen")
	end
	describe "GET index" do
        it "return all movies" do
            get :index
            
            expect(assigns[:movies]).to include(@mov1)
            expect(assigns[:movies]).to include(@mov2)
        end
        
        it "should render template" do

            get :index
            
            expect(response).to render_template("index")
        end
  end

  describe "GET show" do
        it "show one specific movie" do
            get :show, :id => @mov1.id
            expect(assigns[:movie]).to eq(@mov1) 
            expect(response).to render_template("show")
        end
  end

	describe "GET new" do
				it "returns new movie edge" do
						get :new
						expect(response).to render_template("new")
				end
	end

	describe "GET edit" do
        it "should render to edit template" do
            get :edit, :id => @mov1.id
            expect(response).to render_template("edit")
        end
        
    end

	describe "PUT update" do
        it "should change movie attribute and redirects" do
            put :update ,  :id => @mov2.id, :movie=> { title: "Farewell My Concubine", rating: "R" }
            expect(assigns[:movie].title).to eq("Farewell My Concubine")
            expect(assigns[:movie].rating).to eq("R")
            expect(response).to redirect_to movie_path(@mov2)
        end
    end

	describe "GET similar" do
			context "given movie has a director" do
				it "returns all movies with same director" do
					get :similar, :id => @mov2.id
					 expect(response).to render_template("similar")
				end
			end

			context "given movie has no directors" do
				it "returns to index page" do
					get :similar, :id => @mov3.id
					 expect(response).to redirect_to movies_path
				end
			end
	end
end
