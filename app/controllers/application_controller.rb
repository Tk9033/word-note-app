class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

   before_action :require_login

  private

  # Sorceryの未認証時ハンドラ
  def not_authenticated
    redirect_to login_path, alert: I18n.t("auth.login_required", default: "ログインしてください")
  end
end
