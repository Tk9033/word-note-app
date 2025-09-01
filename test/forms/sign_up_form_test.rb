require "test_helper"

class SignUpFormTest < ActiveSupport::TestCase
  test "email is normalized in setter" do
    f = SignUpForm.new(email: "  USER@ExAMPLE.com  ")
    assert_equal "user@example.com", f.email
  end

  test "email format is validated" do
    f = SignUpForm.new(name: "x", email: "//user@example.com", password: "password", password_confirmation: "password")
    assert_not f.valid?
    assert f.errors[:email].present?
  end
end
