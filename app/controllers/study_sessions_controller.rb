class StudySessionsController < ApplicationController
  before_action :set_deck
  before_action :set_session, only: %i[show answer back result retry_wrong]

  # セッション作成
  def create
    if @deck.cards.empty?
      redirect_to deck_path(@deck), alert: t(".no_cards")
      return
    end

    @deck.study_sessions.where(status: :in_progress).destroy_all

    @session = @deck.study_sessions.create!
    redirect_to deck_study_session_path(@deck, @session), notice: t(".success")
  end

  # 問題表示
  def show
    if @session.finished?
      return redirect_to result_deck_study_session_path(@deck, @session)
    end
    @card = @session.current_card
    @reveal = ActiveModel::Type::Boolean.new.cast(params[:reveal])
  end

  # 解答
  def answer
    card = @session.deck.cards.find(params[:card_id])

    correct = ActiveModel::Type::Boolean.new.cast(params[:correct])
    unless @session.record_and_advance!(card: card, correct: correct)
      flash[:alert] = t(".answer_failed")
      return redirect_to deck_study_session_path(@deck, @session)
    end

      redirect_to deck_study_session_path(@deck, @session)
  end

  # 一つ前の問題へ戻る
  def back
    @session.go_back!
    redirect_to deck_study_session_path(@deck, @session)
  end

  # 結果表示
  def result
  results = @session.study_results.includes(:card)

  @total         = @session.card_order.size
  @answered      = results.size
  @correct_count = results.where(correct: true).count
  @wrong_results = results.where(correct: false).to_a

  if @session.finished? && @correct_count == @total && @total.positive?
    flash.now[:notice] = t(".all_correct")
  end
end

  # 不正解だけで新しく問題を作成
  def retry_wrong
    wrong_ids = @session.study_results.where(correct: false).pluck(:card_id)

    if wrong_ids.empty?
      return redirect_to result_deck_study_session_path(@deck, @session),
      notice: t(".no_wrong_answers")
    end

    new_session = @deck.study_sessions.create!(
      status: :in_progress,
      card_order: wrong_ids.shuffle,
      current_index: 0
    )

    redirect_to deck_study_session_path(@deck, new_session), notice: t(".retry_start")
  end

  private

  def set_deck
    @deck = Deck.find(params[:deck_id])
  end

  def set_session
    @session = @deck.study_sessions.includes(deck: :cards).find(params[:id])
  end
end
