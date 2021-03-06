class VideosController < ApplicationController

  before_filter :require_logged_in

  def index
    @categories = Category.all
  end

  def show
    @video = VideoDecorator.decorate(Video.find(params[:id]))
    @reviews = @video.reviews
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end

  def advanced_search
    if params[:query]
      @results = Video.search(params[:query]).records.to_a
    else
      @result = []
    end
  end

end
