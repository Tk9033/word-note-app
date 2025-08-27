require "test_helper"

class StudySessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_user
    log_in_as(@user)
    assert_response :redirect
    follow_redirect!
    assert_response :success

    @deck = Deck.create!(name: "DeckOne-#{SecureRandom.hex(4)}", user: @user)
    @card = @deck.cards.create!(question: "Q1", answer: "A1")
  end

  test "should_create_session" do
    assert_difference("StudySession.count", 1) do
      post deck_study_sessions_path(@deck)
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "should_show_session" do
    session = StudySession.create!(deck: @deck, status: :in_progress, card_order: @deck.card_ids, current_index: 0)
    get deck_study_session_path(@deck, session)
    assert_response :success
  end

  test "should_answer_and_advance" do
    session = StudySession.create!(deck: @deck, status: :in_progress, card_order: @deck.card_ids, current_index: 0)

    assert_difference("StudyResult.count", 1) do
      post answer_deck_study_session_path(@deck, session), params: {
        card_id: @card.id,
        correct: "true"
      }
    end

    session.reload
    assert_equal 1, session.current_index
  end
end
