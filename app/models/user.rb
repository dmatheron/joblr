class User < ActiveRecord::Base

  attr_accessible :fullname, :email, :city, :country, :role, :company, :subdomain, :password, :password_confirmation,
                  :remember_me, :image, :username, :profiles_attributes, :remove_image, :commit, :remote_image_url
  attr_accessor   :commit

  has_many :authentifications, dependent: :destroy
  has_many :profiles,          dependent: :destroy

  accepts_nested_attributes_for :profiles, allow_destroy: true

  validates :username, length:     { maximum: 100 }
  validates :fullname, length:     { maximum: 100 }
  validates :city,     length:     { maximum: 50 }
  validates :country,  length:     { maximum: 50 }
  validates :role,     length:     { maximum: 100 }
  validates :company,  length:     { maximum: 50 }
  validates :username, uniqueness: { case_sensitive: true},            presence: true
  validates :email,    uniqueness: { case_sensitive: false },          allow_blank: false, if: :email_changed?
  validates :email,    format:     { with: Devise.email_regexp },                          if: :email_changed?
  validates :password, length:     { within: Devise.password_length }, confirmation: true, presence: true, if: ->(u) { u.commit == 'Sign up' }

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :omniauthable

  mount_uploader :image, UserImageUploader

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def has_provider?(provider)
    unless provider == :all
      !authentifications.where(:provider => provider).empty?
    else
      has_provider?('linkedin') && has_provider?('twitter') && has_provider?('facebook') && has_provider?('google')
    end
  end

  def auths_w_pic
    authentifications.where("upic != ''")
  end

  def profile
    profiles.first
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  fullname               :string(255)
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  city                   :string(255)
#  country                :string(255)
#  role                   :string(255)
#  company                :string(255)
#  image                  :string(255)
#

