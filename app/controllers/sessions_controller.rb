class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
  @login_form = LoginForm.new
  end

  def create
    @login_form = LoginForm.new(login_params)

    if @login_form.invalid?
      return render :new, status: :unprocessable_entity
    end

    if login(@login_form.email, @login_form.password, @login_form.remember_me)
      redirect_to root_path, notice: "ログインしました"
    else
      @login_form.errors.add(:base, "メールアドレスまたはパスワードが正しくありません")
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to login_path, notice: "ログアウトしました"
  end

  private

  def login_params
    params.require(:login_form).permit(:email, :password, :remember_me)
  end
end
