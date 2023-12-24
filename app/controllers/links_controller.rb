# app/controllers/links_controller.rb
class LinksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

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

  def destroy
    @link = current_user.links.find(params[:id])

    if @link.destroy
      redirect_to links_path, notice: 'Link was successfully deleted.'
    else
      redirect_to links_path, alert: 'Failed to delete the link.'
    end
  end

  private

  def link_params
    params.require(:link).permit(:title, :url)
  end
end
