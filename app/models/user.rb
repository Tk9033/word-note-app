class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :decks, dependent: :destroy

  before_validation :normalize_email

  EMAIL_REGEX = /\A[a-z0-9]+([._%+\-][a-z0-9]+)*@[a-z0-9\-]+(\.[a-z0-9\-]+)*\.[a-z]{2,}\z/i

  validates :name, presence: true, length: { maximum: 30 }
  validates :email,
    presence: true,
    length: { maximum: 254 },
    format: { with: EMAIL_REGEX },
    uniqueness: { case_sensitive: false }

  validates :password, presence: true, if: -> { new_record? || will_save_change_to_attribute?(:crypted_password) }
  validates :password, confirmation: true, if: -> { password.present? }

  private
  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
