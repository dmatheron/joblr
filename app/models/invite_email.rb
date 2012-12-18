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
#  used               :boolean          default(FALSE)
#

class InviteEmail < Email

  attr_accessible :email, :code, :sent, :used, :user_id

  belongs_to :user

  validates :recipient_email, uniqueness: { case_sensitive: true }
  validates :code, presence: true
  validates :sent, inclusion:  { :in => [true, false] }

  before_validation :prefill_fields, :make_code
  after_save        :update_users_email, if: :used_changed?

  private

    def prefill_fields
      self.author_fullname    = 'Joblr'
      self.author_email       = 'postman@joblr.co'
      self.recipient_fullname = 'Unknown'
    end

    def make_code
      self.code = Digest::SHA2.hexdigest(Time.now.utc.to_s) unless persisted?
    end

    def update_users_email
      if used? && user && user.email.nil?
        user.update_attributes email: recipient_email
      end
    end
end
