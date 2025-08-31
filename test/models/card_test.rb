require "test_helper"

class CardTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      email: "cardtest@example.com",
      password: "password",
      password_confirmation: "password",
      name: "Card Tester"
    )
    @deck = Deck.create!(name: "DeckForCardTest-#{SecureRandom.hex(4)}", user: @user)
    @card = @deck.cards.build(question: "Q1", answer: "A1")
  end

  test "should be valid" do
    assert @card.valid?
  end

  test "deck_id should be present" do
    @card.deck = nil
    assert_not @card.valid?
  end

  test "question should be present" do
    @card.question = " "
    assert_not @card.valid?
  end

  test "answer should be present" do
    @card.answer = " "
    assert_not @card.valid?
  end
end
