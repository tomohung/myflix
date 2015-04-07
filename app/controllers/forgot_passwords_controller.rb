class ForgotPasswordsController < ApplicationController

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user
      AppMailer.delay.send_forgot_password_email(user)
      redirect_to forgot_password_confirm_path
    else
      flash[:danger] = "Input is invalid."
      redirect_to forgot_password_path
    end
  end

  def show; end

end