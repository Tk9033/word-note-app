require "test_helper"
require "securerandom"

class DecksIndexVisibilityTest < ActionDispatch::IntegrationTest
  test "only own decks are listed" do
    me  = User.create!(name: "me",  email: "me@example.com",  password: "password")
    you = User.create!(name: "you", email: "you@example.com", password: "password")

    mine  = "Mine-#{SecureRandom.hex(4)}"
    yours = "Yours-#{SecureRandom.hex(4)}"

    Deck.create!(name: mine,  user: me)
    Deck.create!(name: yours, user: you)

    login_as(me)
    get decks_path
    assert_response :success
    assert_includes  @response.body, mine
    refute_includes  @response.body, yours
  end
end
