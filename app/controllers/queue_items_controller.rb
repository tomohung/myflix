class QueueItemsController < ApplicationController

  before_filter :require_logged_in

  def index
    if logged_in?
      @queue_items = current_user.queue_items
    else
      redirect_to sign_in_path
    end
  end

  def create

    video = Video.find(params[:video_id])
    if video && !current_user.queue_include?(video)
      queue_item = QueueItem.new(user: current_user, video: video)
      queue_item.position = current_user.queue_items.count + 1
      queue_item.save
    end
    redirect_to my_queue_path
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if queue_item.user == current_user
    redirect_to my_queue_path
  end

  def update_queue
    binding.pry
  end

end