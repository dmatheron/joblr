# == Schema Information
#
# Table name: emails
#
#  id                 :integer          not null, primary key
#  author_fullname    :string(255)
#  author_email       :string(255)
#  recipient_fullname :string(255)
#  recipient_email    :string(255)
#  cc                 :string(255)
#  bcc                :string(255)
#  subject            :string(255)
#  text               :text
#  status             :string(255)
#  type               :string(255)
#  profile_id         :integer
#  author_id          :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  page               :string(255)
#  code               :string(255)
#  user_id            :integer
#  sent               :boolean          default(FALSE)
#

require 'spec_helper'

describe ProfileEmail do

	before :each do
		@author    = FactoryGirl.create :author
		@profile   = FactoryGirl.create :profile, user: @author
		@user_profile_email   = FactoryGirl.create :profile_email, profile: @profile, author: @author
		@public_profile_email	= FactoryGirl.create :profile_email, profile: @profile, author: nil
	end

  it 'should inherit from the UserEmail model' do
    ProfileEmail.should < UserEmail
  end

	describe 'Profile association' do
		it { @user_profile_email.should respond_to :profile }

		it 'should have the right associated profile' do
			@user_profile_email.profile_id.should == @profile.id
			@user_profile_email.profile.should == @profile
		end

		it 'should not destroy the associated profile' do
			@user_profile_email.destroy
			Profile.find_by_id(@user_profile_email.profile_id).should_not be_nil
		end
	end

  describe 'Validations' do

    context 'user profile email' do
      it { @user_profile_email.should_not validate_presence_of :author_fullname }
      it { @user_profile_email.should_not ensure_length_of(:author_fullname).is_at_most 100 }
      it { @user_profile_email.should_not validate_presence_of :author_email }
    end

		context 'public profile email' do
  		it { @public_profile_email.should validate_presence_of :author_fullname }
  		it { @public_profile_email.should ensure_length_of(:author_fullname).is_at_most 100 }
  		it { @public_profile_email.should validate_presence_of :author_email }
		end

    it { should validate_presence_of(:text) }
    it { should ensure_length_of(:text).is_at_most 140 }
    it { should ensure_inclusion_of(:status).in_array ['accepted', 'declined'] }
	end
end
