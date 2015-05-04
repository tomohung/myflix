class AdminController < ApplicationController

  before_filter :require_logged_in
  before_filter :require_admin

  def require_admin
    if !current_user.admin?
      flash[:danger] = 'You do not have access right.'
      redirect_to home_path
    end
  end      
end
