require "test_helper"

class StudySessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)

    # fixtures に decks(:one) があれば使う。無ければ新規作成。
    deck_record = (decks(:one) rescue nil)
    @deck = deck_record.is_a?(Deck) ? deck_record : Deck.create!(name: "DeckOne")

    # セッション作成がスキップされないよう最低2枚カードを用意
    @deck.cards.create!(question: "Q1", answer: "A1") if @deck.cards.empty?
    @deck.cards.create!(question: "Q2", answer: "A2") if @deck.cards.size < 2

    log_in_as(@user)
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
         params:  { card_id: current_card.id, correct: true }
    assert_response :redirect

    study_session.reload
    assert_equal 1, study_session.current_index
  end

  test "should go back" do
    post deck_study_sessions_path(@deck)
    study_session = @deck.study_sessions.order(:created_at).last

    current = study_session.current_card || @deck.cards.first
    post answer_deck_study_session_path(@deck, study_session),
         params:  { card_id: current.id, correct: true }
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
