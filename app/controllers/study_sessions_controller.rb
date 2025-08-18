class StudySessionsController < ApplicationController
  before_action :set_deck
  before_action :set_session, only: %i[show answer back result retry_wrong]

  # セッション作成
  def create
    if @deck.cards.empty?
      redirect_to deck_path(@deck), alert: "このフォルダにはカードがありません。"
      return
    end

    @session = @deck.study_sessions.create!(
      status: :in_progress,
      current_index: 0
    )
    redirect_to deck_study_session_path(@deck, @session)
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
    # @session.deck.cards は set_session で事前読み込み済みのため、DB問い合わせが発生しない
    card = @session.deck.cards.find { |c| c.id == params[:card_id].to_i }

    correct = ActiveModel::Type::Boolean.new.cast(params[:correct])
    unless @session.record_and_advance!(card: card, correct: correct)
      flash[:alert] = "回答の保存に失敗しました。 もう一度お試しください。"
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
    @total = @session.card_order.size
    results = @session.study_results.includes(:card).to_a
    @answered = results.size
    @correct_count = results.count(&:correct)
    @wrong_results = results.reject(&:correct)

    if @session.finished? && @correct_count == @total && @total.positive?
      flash.now[:notice] = "全問正解！おめでとう！"
    end
  end

  # 不正解だけで新しく問題を作成
  def retry_wrong
    wrong_ids = @session.study_results.where(correct: false).pluck(:card_id)

    if wrong_ids.empty?
      return redirect_to result_deck_study_session_path(@deck, @session),
      notice: "不正解はありません。"
    end

    new_session = @deck.study_sessions.create!(
      status: :in_progress,
      card_order: wrong_ids.shuffle,
      current_index: 0
    )

    redirect_to deck_study_session_path(@deck, new_session)
  end

  private

  def set_deck
    @deck = Deck.find(params[:deck_id])
  end

  def set_session
    @session = @deck.study_sessions.includes(deck: :cards).find(params[:id])
  end
end
