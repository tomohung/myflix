class PasswordResetsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.find_by(token: params[:token])
    if user
      user.update(password: params[:password], token: SecureRandom.urlsafe_base64)
      flash[:notice] = 'User password has changed.'
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end

  def expired_token; end

end