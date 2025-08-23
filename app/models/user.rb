class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :decks, dependent: :destroy

  before_validation { email&.downcase!&.strip! }

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, if: -> { new_record? || will_save_change_to_attribute?(:crypted_password) }
  validates :password, confirmation: true
end
