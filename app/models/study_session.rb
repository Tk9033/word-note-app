class StudySession < ApplicationRecord
  belongs_to :deck
  has_many :study_results, dependent: :destroy
  has_many :answered_cards, through: :study_results, source: :card

  enum :status, { in_progress: 0, completed: 1 }

  before_validation :set_card_order, on: :create

  def current_card
    return nil if finished?
    deck.cards.find { |card| card.id == card_order[current_index] }
  end

  def record_and_advance!(card:, correct:)
    return false unless card == current_card

  with_lock do
    transaction do
      sr = study_results.find_or_initialize_by(card: card)
      sr.correct = correct
      sr.save!

      new_index = current_index + 1
      attributes_to_update = { current_index: new_index }
      attributes_to_update[:status] = :completed if new_index >= card_order.size
      update!(attributes_to_update)
    end
  end
  true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def go_back!
    if current_index > 0
      update!(current_index: self.current_index - 1)
    end
  end

  def finished?
    current_index >= card_order.size
  end

  private

  def set_card_order
    return unless card_order.blank?
    ids = deck&.card_ids || []
    self.card_order = ids.shuffle
  end
end
