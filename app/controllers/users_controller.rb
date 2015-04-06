class UsersController < ApplicationController

  before_filter :require_logged_in, only: [:show]

  def new    
    @user = User.new
  end

  def create    
    @user = User.new(user_params)
    if @user.save
      set_following_relationship
      AppMailer.send_welcome_email(@user).deliver
      session[:user_id] = @user.id
      redirect_to home_path
    else
      render 'new'
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

  def set_following_relationship
    if params[:token].present?
      invitation = Invitation.find_by(token: params[:token])
      if invitation
        invitation.inviter.follow(@user)
        @user.follow(invitation.inviter)
        invitation.update(token: nil)
      end
    end
  end

end
