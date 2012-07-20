require 'spec_helper'

describe UsersController do

  before :each do
    @user = FactoryGirl.create :user
    sign_in @user
    @attr = { fullname: 'Tony Leung', city: 'Hong Kong', country: 'China', role: 'Mole', company: 'HK triads',
              profiles_attributes: { '0' => { experience: '10', education: 'none' } } }
  end

  describe "GET 'edit'" do

    before(:each) { get :edit, id: @user }

    it { response.should be_success }
  end

  describe "PUT 'update" do

    it 'should update the user' do
      put :update, user: @attr, id: @user
      updated_user = assigns :user
      @user.reload
      @user.fullname.should == updated_user.fullname
    end

    it 'should not create a new user' do
      lambda do
        put :update, user: @attr, id: @user
      end.should_not change(User, :count)
    end

    it 'should create a profile' do
      lambda do
        put :update, user: @attr, id: @user
      end.should change(Profile, :count).by(1)
    end

    it "should redirect to the 'show' page" do
      put :update, user: @attr, id: @user
      response.should redirect_to @user
    end
  end
end