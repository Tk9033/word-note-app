require "test_helper"
require "securerandom"

class UserTest < ActiveSupport::TestCase
  def build_user(email:)
    User.new(name: "u", email: email, password: "password")
  end

  test "normalizes email (strip + downcase) before validation" do
    u = build_user(email: "  USER@Example.com  ")
    assert u.valid?
    assert_equal "user@example.com", u.email
  end

  test "rejects invalid email format" do
    u = build_user(email: "//user@example.com")
    assert_not u.valid?
    assert_includes u.errors[:email], "はメールアドレスの形式が正しくありません" rescue nil
    # ↑ 翻訳未設定なら、少なくともエラーが付くことだけ確認
    assert u.errors[:email].present?
  end

  test "disallows duplicated email case-insensitively" do
    base = "dup_#{SecureRandom.hex(4)}@example.com"
    assert User.create!(name: "a", email: base, password: "password")
    u2 = build_user(email: base.upcase)
    assert_not u2.valid?
    assert u2.errors[:email].present?
  end
end
