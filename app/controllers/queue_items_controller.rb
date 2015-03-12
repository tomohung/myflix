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
    current_user.normalize_queue_items
    redirect_to my_queue_path
  end

  def update_queue
    begin
      if params[:queue_items]
        ActiveRecord::Base.transaction do
          params[:queue_items].each do |queue_item_data|
            queue_item = QueueItem.find(queue_item_data["id"])
            queue_item.update!(position: queue_item_data["position"])
          end
        end
      end
    rescue ActiveRecord::RecordInvalid
      flash[:error] = 'Invalid position numbers.'      
    end  

    current_user.normalize_queue_items
    redirect_to my_queue_path
  end

end