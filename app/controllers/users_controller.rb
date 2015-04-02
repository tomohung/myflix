class UsersController < ApplicationController

  before_filter :require_logged_in, only: [:show]

  def new    
    @user = User.new
  end

  def create    
    @user = User.new(params.require(:user).permit!)
    if @user.save
      AppMailer.send_welcome_email(@user).deliver
      session[:user_id] = @user.id
      redirect_to home_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

end
