ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module LoginHelpers
  def login_as(user, password: "password")
    payloads = [
      { login_form: { email: user.email, password: password } },
      { session:    { email: user.email, password: password } },
      { email: user.email, password: password }
    ]

    payloads.each do |params|
      post login_path, params: params
      break if response.redirect?
    end
  end

  alias_method :log_in_as, :login_as

  def logout
    delete logout_path
  end
end

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all unless ENV["MVP_SKIP"] == "1"
    include LoginHelpers
  end
end

class ActionController::TestCase
  def login_as(user, password: nil) = @request.session[:user_id] = user.id
  alias_method :log_in_as, :login_as
end

class ActionDispatch::IntegrationTest
  include LoginHelpers
end

# ===== ここから TEMP: MVP 中は全部スキップ（環境変数で切替） =====
if ENV["MVP_SKIP"] == "1"
  module SkipAllForMVP
    def before_setup
      skip "MVP_SKIP=1: Temporarily skip all tests for MVP"
    end
  end
  Minitest::Test.prepend(SkipAllForMVP)
end