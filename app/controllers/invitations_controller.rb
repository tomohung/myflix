class InvitationsController < ApplicationController

  before_filter :require_logged_in

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)
    
    if @invitation.save
      AppMailer.send_invitation_email(current_user, @invitation).deliver
      flash[:success] = 'Invitaiton has been sent.'
      redirect_to new_invitation_path
    else
      flash[:danger] = 'Invitation is invalid.'
      render :new
    end
  end

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message).merge!(inviter_id: current_user.id)
  end

end