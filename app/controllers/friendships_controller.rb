# frozen_string_literal: true

class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend = User.find(params[:friend_id])
    current_user.sent_friend_requests.create(friend: friend)
    redirect_to users_path, notice: 'Friend request sent!'
  end

  def update
    friendship = Friendship.find(params[:id])
    friendship.accepted!
    redirect_to users_path, notice: 'Friend request accepted!'
  end

  def destroy
    friendship = Friendship.find(params[:id])
    friendship.destroy
    redirect_to users_path, notice: 'Friend request declined!'
  end
end
