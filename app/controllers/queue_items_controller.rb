class QueueItemsController < ApplicationController

  def index
    if logged_in?
      @queue_items = current_user.queue_items
    else
      redirect_to sign_in_path
    end
  end

end