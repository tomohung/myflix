class ReviewsController < ApplicationController

  def create
    @video = Video.find(params[:video_id])    
    @review = Review.new(set_params)
    @review.user = current_user
    @review.video = @video
    @review.save
    redirect_to @video
  end

  private

  def set_params
    params.require(:review).permit(:context, :user_id, :video_id, :rating)
  end

end