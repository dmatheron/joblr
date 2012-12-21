require 'spec_helper'

describe PagesController do

	render_views

	before :each do
		@user  = FactoryGirl.create :user
		@admin = FactoryGirl.create :user, fullname: FactoryGirl.generate(:fullname), username: FactoryGirl.generate(:username), email: FactoryGirl.generate(:email), admin: true
	end

	describe "GET 'landing'" do

		context 'for public users' do
			before :each do
				get :landing
			end

			it { response.should be_success }

			it 'should have the right content' do
				response.body.should include I18n.t('pages.landing.catchphrase')
				response.body.should include I18n.t('pages.landing.subtitle')
				response.body.should include I18n.t('pages.landing.join')
				response.body.should include I18n.t('pages.landing.benefit1_title')
				response.body.should include I18n.t('pages.landing.benefit1_text')
				response.body.should include I18n.t('pages.landing.benefit2_title')
				response.body.should include I18n.t('pages.landing.benefit2_text')
				response.body.should include I18n.t('pages.landing.benefit3_title')
				response.body.should include I18n.t('pages.landing.benefit3_text_html')
				response.body.should include I18n.t('pages.landing.benefit4_title')
				response.body.should include I18n.t('pages.landing.benefit4_text')
				response.body.should include I18n.t('pages.landing.disclaimer_html')
			end

			it 'should have kissmetrics event' do
				response.body.should have_content "_kmq.push(['record', 'Viewed landing page'])"
			end

			it 'should have mixpanel event' do
				response.body.should have_content "mixpanel.track('Viewed landing page')"
			end
		end

		context 'for signed in users' do
			before :each do
				sign_in @user
				get :landing
			end

			it 'should have kissmetrics event' do
				response.body.should have_content "_kmq.push(['identity', '#{@user.username}'])"
			end

			it 'should have mixpanel event' do
				response.body.should have_content "mixpanel.identify('#{@user.username}')"
			end
		end
	end

	describe "GET 'admin'" do

		context 'for public users' do

			before :each do
				get :admin
			end

			it 'should redirect to root path' do
				response.should redirect_to(root_path)
				flash[:error].should == I18n.t('flash.error.only.admin')
			end
		end

		context 'for signed in users' do

			context 'who are not admin' do

				before :each do
					sign_in @user
					get :admin
				end

				it 'should redirect to root path' do
					response.should redirect_to(root_path)
					flash[:error].should == I18n.t('flash.error.only.admin')
				end
			end

			context 'who are admin' do

				before :each do
					sign_in @admin
					get :admin
				end

				it { response.should be_success }

				it 'should have an admin block' do
					response.body.should have_selector 'div.admin'
				end

				it 'should have kissmetrics event' do
					response.body.should have_content "_kmq.push(['identity', '#{@admin.username}'])"
				end
			end
		end
	end

	describe "GET 'style tile'" do

		context 'for public users' do

			before :each do
				get :style_tile
			end

			it 'should redirect to root path' do
				response.should redirect_to(root_path)
				flash[:error].should == I18n.t('flash.error.only.admin')
			end
		end

		context 'for signed in users' do

			context 'who are not admin' do

				before :each do
					sign_in @user
					get :style_tile
				end

				it 'should redirect to root path' do
					response.should redirect_to(root_path)
					flash[:error].should == I18n.t('flash.error.only.admin')
				end
		  end

			context 'who are admin' do

				before :each do
					sign_in @admin
					get :style_tile
				end

				it { response.should be_success }

				it 'should have a style_tile block' do
					response.body.should have_selector 'div#style-tile'
				end
			end
		end
	end
end