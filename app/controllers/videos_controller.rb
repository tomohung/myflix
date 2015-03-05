class VideosController < ApplicationController

  before_filter :require_logged_in

  def index
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end

end