require "securerandom"
require "test_helper"

class StudySessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    # 毎回確実にログインできるユーザーを作る
    @user = User.create!(
      name: "u1",
      email: "u1+#{SecureRandom.hex(4)}@example.com",
      password: "password"
    )

    # ログインユーザー所有のデッキを必ず作る
    @deck = Deck.create!(name: "Deck-#{SecureRandom.hex(6)}", user: @user)

    # 最低2枚のカードを用意（作成ロジックに依存しているため）
    @deck.cards.create!(question: "Q1", answer: "A1")
    @deck.cards.create!(question: "Q2", answer: "A2")

    # ログイン
    login_as(@user)
  end

  test "should create session" do
    assert_difference "StudySession.count", +1 do
      post deck_study_sessions_path(@deck)
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "should show session" do
    post deck_study_sessions_path(@deck)
    study_session = @deck.study_sessions.order(:created_at).last

    get deck_study_session_path(@deck, study_session)
    assert_response :success
  end

  test "should answer and advance" do
    post deck_study_sessions_path(@deck)
    study_session = @deck.study_sessions.order(:created_at).last

    current_card = study_session.current_card || @deck.cards.first
    post answer_deck_study_session_path(@deck, study_session),
         params: { card_id: current_card.id, correct: true }
    assert_response :redirect

    study_session.reload
    assert_equal 1, study_session.current_index
  end

  test "should go back" do
    post deck_study_sessions_path(@deck)
    study_session = @deck.study_sessions.order(:created_at).last

    current = study_session.current_card || @deck.cards.first
    post answer_deck_study_session_path(@deck, study_session),
         params: { card_id: current.id, correct: true }
    study_session.reload
    assert_equal 1, study_session.current_index

    post back_deck_study_session_path(@deck, study_session)
    study_session.reload
    assert_equal 0, study_session.current_index
  end

  test "should show result" do
    post deck_study_sessions_path(@deck)
    study_session = @deck.study_sessions.order(:created_at).last

    get result_deck_study_session_path(@deck, study_session)
    assert_response :success
  end
end