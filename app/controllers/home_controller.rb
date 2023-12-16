# app/controllers/home_controller.rb
class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:index, :create]

  def index
    @user = User.new
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

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
