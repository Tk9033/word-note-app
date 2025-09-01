require "test_helper"

class SignupEmailValidationTest < ActionDispatch::IntegrationTest
  test "rejects invalid email format on signup" do
    assert_no_difference "User.count" do
      post users_path, params: {
        sign_up_form: {
          name:  "x",
          email: "//user1@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }
    end
    assert_response :unprocessable_entity
    # 文言は環境によって異なるので、厳密一致は避ける
    assert_match(/メール|不正|形式/, @response.body)
  end
end
