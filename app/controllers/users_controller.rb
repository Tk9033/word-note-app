class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    return redirect_to(decks_path) if logged_in?
    @sign_up_form = SignUpForm.new
  end

  def create
    @sign_up_form = SignUpForm.new(sign_up_form_params)
    return render :new, status: :unprocessable_entity if @sign_up_form.invalid?

    user = User.new(
      name: @sign_up_form.name,
      email: @sign_up_form.email,
      password: @sign_up_form.password
    )

  if user.save
    auto_login(user)
    redirect_to decks_path, notice: t("auth.logged_in", default: "ログインしました")
  else
    user.errors.each do |attr, msg|
      mapped_attr = (attr == :crypted_password) ? :password : attr
      @sign_up_form.errors.add(mapped_attr, msg)
    end
    render :new, status: :unprocessable_entity
  end
end
  private

  def sign_up_form_params
    params
      .require(:sign_up_form)
      .permit(:name, :email, :password, :password_confirmation)
      .tap do |raw|
        raw[:email] = raw[:email].to_s.strip.downcase
      end
  end
end
