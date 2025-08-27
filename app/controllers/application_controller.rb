class ApplicationController < ActionController::Base
  allow_browser versions: :modern

   before_action :require_login

  private

  def not_authenticated
    redirect_to login_path, alert: I18n.t("auth.login_required", default: "ログインしてください")
  end
end
