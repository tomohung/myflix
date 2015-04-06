class PasswordResetsController < ApplicationController
  def show
    user = User.where(token: params[:id]).take
    if user
      @token = user.token
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.where(token: params[:token]).take
    if user
      user.password = params[:password]
      user.generate_token
      user.save
      flash[:notice] = 'User password has changed.'
      redirect_to sign_in_path
    else
      redirect_to expired_token_path
    end
  end

  def expired_token
  end

end