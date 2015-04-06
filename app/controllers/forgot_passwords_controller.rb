class ForgotPasswordsController < ApplicationController

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user
      AppMailer.send_forgot_password_email(user).deliver
      redirect_to forgot_password_confirm_path
    else
      flash[:error] = params[:email].blank? ? 'email input can not be blank.' : 'email is not existed.'
      redirect_to forgot_password_path
    end
  end

  def show; end

end