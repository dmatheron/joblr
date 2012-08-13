require 'spec_helper'

describe SharingsController do
	
	render_views

	before :each do
		@author    = FactoryGirl.create :user
		sign_in @author
		@recipient = FactoryGirl.create :user, username: FactoryGirl.generate(:username), fullname: FactoryGirl.generate(:fullname)
		@profile_attr = { education: 'Master of Business Administration',
                  experience: '5 yrs',
                  skill_1: 'Financial control',
                  skill_2: 'Business analysis',
                  skill_3: 'Strategic decision making',
                  skill_1_level: 'Expert',
                  skill_2_level: 'Beginner',
                  skill_3_level: 'Intermediate',
                  quality_1: 'Drive',
                  quality_2: 'Work ethics',
                  quality_3: 'Punctuality',
                  text: 'Do or do not, there is no try.' }
    @sharing_attr = { author_id: @author.id,
    									text: "Hi, I'm really keen to work for your company and would love to go over a few ideas together soon."}
	end

	describe "GET 'new'" do

    context "user hasn't completed his profile" do

      it "should redirect to 'edit'" do
        get :new
        response.should redirect_to edit_user_path(@author)
      end
    end

    context 'user has completed his profile' do

      before :each do
        @author.profiles.create @profile_attr
        get :new
      end

	    it { response.should be_success }

	    it 'should have a card with the author profile' do
	    	response.body.should have_selector 'div', class:'card', id:"show-user-#{@author.id}"
	    end
    end
	end

	describe "POST 'create'" do
		before :each do
      @author.profiles.create @profile_attr
		end

    it { response.should be_success }

    context 'user typed an email address' do
			it 'should create a new sharing object' do
				lambda do
					post :create, :sharing => @sharing_attr, :email => "test@test.com"
				end.should change(Sharing,:count).by 1
			end

	    it "should redirect to user's profile" do
	    	post :create, :sharing => @sharing_attr, :email => "test@test.com"
	    	response.should redirect_to @author
	    end
    end

    context "user didn't type an email address" do
			it 'should not create a new sharing object' do
				lambda do
					post :create, :sharing => @sharing_attr
				end.should_not change(Sharing,:count).by 1
			end

	    it "should redirect to user's profile" do
	    	post :create, :sharing => @sharing_attr
	    	response.should redirect_to new_sharing_path
	    end
    end    
	end	
end