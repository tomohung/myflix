class Admin::VideosController < ApplicationController

  before_filter :require_logged_in
  before_filter :require_admin

  def new
    @video = Video.new
  end

  def create

  end

  private
  def require_admin
    if !current_user.admin?
      flash[:danger] = 'You do not have access right.'
      redirect_to home_path
    end
  end

end