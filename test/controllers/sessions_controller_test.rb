require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "u", email: "u@example.com", password: "password")
  end

  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should create (login)" do
    login_as(@user)
    assert_response :redirect
    assert_redirected_to decks_path
  end

  test "should not login with wrong password" do
    post login_path, params: { login_form: { email: @user.email, password: "WRONG" } }
    assert_response :unprocessable_entity  # 実装に合わせて :success 等に調整
  end

  test "should destroy (logout) and redirect" do
    log_in_as(@user)
    delete logout_path
    assert_response :redirect
  end
end
