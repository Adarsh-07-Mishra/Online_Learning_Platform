# app/controllers/links_controller.rb
class LinksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    redirect_to action: :all_links
  end

  def all_links
    @links = current_user.links
  end

  def new
    @link = current_user.links.build
  end

  def create
    @link = current_user.links.build(link_params)

    if @link.save
      redirect_to links_path, notice: 'Link was successfully saved.'
    else
      render :new
    end
  end

  private

  def link_params
    params.require(:link).permit(:title, :url)
  end
end
