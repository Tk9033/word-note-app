class StudySession < ApplicationRecord
  belongs_to :deck
  has_many :study_results, dependent: :destroy
  has_many :answered_cards, through: :study_results, source: :card

  enum status: { in_progress: 0, completed: 1 }

  before_validation :set_card_order, on: :create

  def current_card
    return nil if finished?
    # N+1問題を避けるため、事前に読み込んだdeckのcardsから探す
    deck.cards.find { |card| card.id == card_order[current_index] }
  end

  def record_and_advance!(card:, correct:)
    # 現在のカードが解答対象のカードと一致するか確認
    return false unless card == current_card

  with_lock do               # ← 連打対策としてロック（任意だが推奨）
    transaction do
      # 既存があれば上書き、なければ新規作成
      sr = study_results.find_or_initialize_by(card: card)
      sr.correct = correct
      sr.save!

      new_index = current_index + 1
      attributes_to_update = { current_index: new_index }
      # 最後の問題だったら、セッションを完了状態にする
      attributes_to_update[:status] = :completed if new_index >= card_order.size
      update!(attributes_to_update)
    end
  end
  true
  rescue ActiveRecord::RecordInvalid
    false
  end

  # 一つ前の問題へ戻る
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
    # self.card_orderがまだ設定されていない場合のみ、deckの全カードIDをシャッフルして設定
    if card_order.blank?
      self.card_order = deck.card_ids.shuffle
    end
  end
end
