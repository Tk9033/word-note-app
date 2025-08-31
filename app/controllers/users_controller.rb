class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @sign_up_form = SignUpForm.new
  end

  def create
    @sign_up_form = SignUpForm.new(sign_up_form_params)

   if @sign_up_form.invalid?
    return render :new, status: :unprocessable_entity
   end

  user = User.new(
    name: @sign_up_form.name,
    email: @sign_up_form.email,
    password: @sign_up_form.password
  )

  if user.save
    auto_login(user)
    redirect_to root_path, notice: t("auth.logged_in", default: "ログインしました")
  else
    user.errors.each do |error|
      mapped_attr = (error.attribute == :password_digest) ? :password : error.attribute
      @sign_up_form.errors.add(mapped_attr, error.message)
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
