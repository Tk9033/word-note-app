ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# （任意）並列実行を使う場合はコメントアウト外す
# parallelize(workers: :number_of_processors)

# ---- フィクスチャと共通ヘルパ ----
class ActiveSupport::TestCase
  # これで test/fixtures/*.yml が使える（decks(:one) など）
  # fixtures :all
  # fixtures :users, :decks
end

# Sorcery用のログイン/ユーザー作成ヘルパ
module AuthHelpers
  def create_user(email: "test@example.com", password: "password")
    User.create!(
      email: email,
      password: password,
      password_confirmation: password,
      name: "テストユーザー"
    )
  end

  def log_in_as(user, password: "password")
    # あなたの SessionsController#create のパラメータに合わせて必要ならキーを変更
    post login_path, params: {
      login_form: {                # ← ココが重要（login_form ネスト）
        email: user.email,
        password: password,
        remember_me: "0"           # チェックなしなら "0"（"1"でもOK）
      }
    }
  end
end

# IntegrationTest（コントローラ統合テスト）で上ヘルパを使えるようにする
class ActionDispatch::IntegrationTest
  include AuthHelpers
end
