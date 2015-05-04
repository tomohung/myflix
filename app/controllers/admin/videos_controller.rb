class Admin::VideosController < AdminController

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
    def video_params
      params.require(:video).permit(:title, :description, :category_id, :large_cover, :small_cover, :video_url)
    end
end
