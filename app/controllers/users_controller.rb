class UsersController < ApplicationController

  before_filter :require_logged_in, only: [:show]

  def new    
    @user = User.new
  end

  def create    
    @user = User.new(user_params)
    user_signup_service = UserSignup.new(@user)
    result = user_signup_service.sign_up(params[:stripeToken], params[:token])

    if result.successful?
      session[:user_id] = @user.id
      redirect_to home_path
    else
      flash.now[:danger] =  user_signup_service.error_message
      render :new
    end
  end

  def show
    @user = User.find_by(token: params[:id])
  end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])    
    
    if invitation
      @user = User.new
      @user.email = invitation.recipient_email
      @user.full_name = invitation.recipient_name
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:full_name, :password, :email)
  end
end
