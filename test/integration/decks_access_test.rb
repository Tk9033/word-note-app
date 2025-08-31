require "test_helper"

class DecksAccessTest < ActionDispatch::IntegrationTest

  setup do
    @owner = User.create!(name: "u1", email: "u1@example.com", password: "password")
    @other = User.create!(name: "u2", email: "u2@example.com", password: "password")
    @others_deck = Deck.create!(name: "Deck B", user: @other)
    @my_deck     = Deck.create!(name: "My Deck", user: @owner)
  end

  test "requires login" do
    get deck_path(@my_deck)
    assert_redirected_to login_path
    follow_redirect!
    assert_includes @response.body, "ログインしてください"
  end

  test "owner can view own deck" do
    login_as(@owner)
    get deck_path(@my_deck)
    assert_response :success
  end

  test "redirects with alert when accessing another user's deck" do
    login_as(@owner)
    get deck_path(@others_deck)
    assert_redirected_to decks_path
    follow_redirect!
    assert_includes @response.body, "ページが見つからないか、閲覧権限がありません。"
  end

  test "redirects when deck does not exist" do
    login_as(@owner)
    get deck_path(9_999_999)
    assert_redirected_to decks_path
  end
end