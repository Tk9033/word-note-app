class Deck < ApplicationRecord
  belongs_to :user
  has_many :cards, dependent: :destroy
  has_many :study_sessions, dependent: :destroy
  validates :name, presence: true, uniqueness: { scope: :user_id }, length: { maximum: 50 }
end
