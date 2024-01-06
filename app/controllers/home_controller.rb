# frozen_string_literal: true

# app/controllers/home_controller.rb
class HomeController < ApplicationController
  before_action :authenticate_user!, except: %i[index create]
  before_action :set_active_storage_url_options, only: [:index]

  def index
    @user = User.new
    @documents = Document.all
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to new_user_session_path, notice: 'Signup successful. Please sign in.'
    else
      render :index
    end
  end

  private

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { host: request.base_url }
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
