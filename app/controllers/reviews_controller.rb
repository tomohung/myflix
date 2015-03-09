class ReviewsController < ApplicationController

  before_filter :require_logged_in

  def create
    @video = Video.find(params[:video_id])    
    review = @video.reviews.new(set_params.merge!(user: current_user))
    
    if review.save
      redirect_to video
    else
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  private

  def set_params
    params.require(:review).permit(:context, :user_id, :video_id, :rating)
  end

end