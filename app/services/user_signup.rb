class UserSignup

  attr_reader :error_message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token = nil, invitation_token = nil)
    if @user.valid?      
      charge = customer_charge_user_with_stripe(stripe_token)
      if charge.success?
        @user.customer_token = charge.customer_token
        @user.save
        set_invitation_following_relationship(invitation_token)
        AppMailer.delay.send_welcome_email(@user)
        @status = :success
        self
      else
        @status = :failed
        @error_message = charge.error_message
        self
      end
    else
      @status = :failed
      @error_message = "User info is invalid."
      self
    end
  end

  def successful?
    @status == :success
  end

private
  def set_invitation_following_relationship(invitation_token)
    if invitation_token.present?
      invitation = Invitation.find_by(token: invitation_token)
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

  def charge_user_with_stripe(token)
    charge = StripeWrapper::Charge.create(
      amount: 3000, # amount in cents, again
      source: token,
      description: "Signs up for #{@user.full_name}"
    )
  end

  def customer_charge_user_with_stripe(token)
    StripeWrapper::Charge.customer(
      source: token,
      email: @user.email
    )
  end
end
