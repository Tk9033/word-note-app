class StudySession < ApplicationRecord
  belongs_to :deck
  has_many :study_results, dependent: :destroy
  has_many :answered_cards, through: :study_results, source: :card

  enum status: { in_progress:0, completed: 1 }

  before_validation :set_card_order, on: :create

  def current_card
    return nil if finished?
    # N+1問題を避けるため、事前に読み込んだdeckのcardsから探す
    deck.cards.find { |card| card.id == card_order[current_index] }
  end

  def record_and_advance!(card:, correct:)
    # 現在のカードが解答対象のカードと一致するか確認
    return false unless card == current_card

    transaction do
      # 解答結果をStudyResultに保存
      study_results.create!(card: card, correct: correct, answered_at: Time.current)
      self.current_index += 1
      # 最後の問題だったら、セッションを完了状態にする
      if finished?
        self.status = :completed
      end
      save!
    end
    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def finished?
    current_index >= card_order.size
  end

  private

  def set_card_order
    # self.card_orderがまだ設定されていない場合のみ、deckの全カードIDをシャッフルして設定
    self.card_order = deck.card_ids.shuffle if card_order.empty?
  end
end
