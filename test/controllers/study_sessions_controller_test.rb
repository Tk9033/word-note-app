require "test_helper"

class StudySessionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @deck = decks(:one)
  end

  test "should create session" do
    assert_difference("StudySession.count", 1) do
      post deck_study_sessions_path(@deck)
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "should show session" do
    session = @deck.study_sessions.create!(status: :in_progress, current_index: 0)
    get deck_study_session_path(@deck, session)
    assert_response :success
  end

  test "should answer and advance" do
    session = @deck.study_sessions.create!(status: :in_progress, current_index: 0)
    current_card = session.current_card
    assert current_card, "current_card が nil です。deck(:one) にカードがあるか確認してください。"

    post answer_deck_study_session_path(@deck, session),
         params: { card_id: current_card.id, correct: true }

    assert_response :redirect

    session.reload
    assert_equal 1, session.current_index
  end

  test "should go back" do
    session = @deck.study_sessions.create!(status: :in_progress, current_index: 1)
    post back_deck_study_session_path(@deck, session)
    assert_response :redirect
    session.reload
    assert_equal 0, session.current_index
  end

  test "should show result" do
    session = @deck.study_sessions.create!(status: :in_progress, current_index: 0)
    get result_deck_study_session_path(@deck, session)
    assert_response :success
  end
end
