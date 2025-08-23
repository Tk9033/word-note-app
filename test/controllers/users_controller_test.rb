require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_path
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count", 1) do
      post users_path, params: {
        sign_up_form: {
          name: "Tester",
          email: "tester@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end
   assert_redirected_to root_path
  end
end
