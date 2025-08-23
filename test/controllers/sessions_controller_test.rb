require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should create (login)" do
    user = users(:one)
    post login_path, params: {
      login_form: { email: user.email, password: "password" }
    }
    assert_redirected_to root_path
  end

  test "should destroy (logout) and redirect" do
    user = users(:one)
    log_in_as(user)
    delete logout_path
    assert_response :redirect
  end
end
