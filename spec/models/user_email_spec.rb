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

describe UserEmail do

  before :each do
    @author     = FactoryGirl.create :user
    @user_email = FactoryGirl.create :user_email, author: @author
  end

  it 'should inherit from the Email model' do
    UserEmail.should < Email
  end

  describe 'Author association' do

    it { @user_email.should respond_to :author }

    it 'should have the right associated author' do
      @user_email.author_id.should == @author.id
      @user_email.author.should    == @author
    end

    it 'should not destroy the associated author' do
      @user_email.destroy
      User.find_by_id(@user_email.author_id).should_not be_nil
    end
  end
end