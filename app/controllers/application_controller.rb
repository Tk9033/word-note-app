class ApplicationController < ActionController::Base
  allow_browser versions: :modern

   before_action :require_login

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  private

  def not_authenticated
    redirect_to login_path, alert: I18n.t("auth.login_required", default: "ログインしてください")
  end

  def handle_not_found
    redirect_to decks_path, alert: "ページが見つからないか、閲覧権限がありません。"
  end
end
