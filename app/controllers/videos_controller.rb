class VideosController < ApplicationController

  def index
    redirect_to sign_in_path if !logged_in?
    @categories = Category.all
  end

  def show
    @video = Video.find(params[:id])
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end

end