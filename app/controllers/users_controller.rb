class UsersController < ApplicationController

  before_filter :require_logged_in, only: [:show]

  def new    
    @user = User.new
  end

  def create    
    @user = User.new(user_params)
    if @user.save
      set_following_relationship
      charge_user_with_stripe
      AppMailer.delay.send_welcome_email(@user)
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
      else
        redirect_to expired_token_path
        return
      end
    end
  end

  def charge_user_with_stripe
    
    # Set your secret key: remember to change this to your live secret key in production
    # See your keys here https://dashboard.stripe.com/account/apikeys
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']

    # Get the credit card details submitted by the form
    token = params[:stripeToken]

    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      charge = Stripe::Charge.create(
        :amount => 3000, # amount in cents, again
        :currency => "usd",
        :source => token,
        :description => 'Signs up for #{@user.full_name}'
      )
    rescue Stripe::CardError => e
      # The card has been declined
      flash[:danger] = e.message
    end
  end

end
