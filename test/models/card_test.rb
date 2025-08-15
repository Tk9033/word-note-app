require "test_helper"

class CardTest < ActiveSupport::TestCase
  def setup
    @deck = decks(:one)
    @card = @deck.cards.build(question: "What is Rails?", answer: "A web framework.")
  end

  test "should be valid" do
    assert @card.valid?
  end

  test "deck id should be present" do
    @card.deck_id = nil
    assert_not @card.valid?
  end

  test "question should be present" do
    @card.question = "   "
    assert_not @card.valid?
  end

  test "answer should be present" do
    @card.answer = "   "
    assert_not @card.valid?
  end
end
