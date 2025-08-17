class Deck < ApplicationRecord
  has_many :cards, dependent: :destroy
  has_many :study_sessions
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
