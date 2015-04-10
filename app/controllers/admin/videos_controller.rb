class Admin::VideosController < ApplicationController

  before_filter :require_logged_in
  before_filter :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have added a new video '#{@video.title}'."
      redirect_to new_admin_video_path
    else
      render :new
    end
  end

  private
    def require_admin
      if !current_user.admin?
        flash[:danger] = 'You do not have access right.'
        redirect_to home_path
      end
    end

    def video_params
      params.require(:video).permit(:title, :description, :category_id)
    end
end