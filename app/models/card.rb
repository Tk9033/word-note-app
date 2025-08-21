class Card < ApplicationRecord
  belongs_to :deck
  validates :question, :answer, presence: true
  validates :question, uniqueness: { scope: :deck_id }
end
