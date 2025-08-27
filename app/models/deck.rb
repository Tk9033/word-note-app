class Deck < ApplicationRecord
  has_many :study_sessions, dependent: :destroy
  has_many :cards, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
