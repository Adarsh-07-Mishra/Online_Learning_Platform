class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id)
    @friendships = current_user.friendships
    @friend_requests = current_user.received_friend_requests.pending
    @friends = current_user.accepted_friends
  end

  def all_users
    @all_users = User.all
  end

  def show
    params[:id]
    @users = User.all
    render 'all_users'
  end

  def send_friend_request
    friend = User.find(params[:id])

    if user_has_pending_request?(friend)
      redirect_to users_path, alert: "Friend request already sent to #{friend.email}."
    elsif user_already_friends?(friend)
      redirect_to users_path, alert: "You are already friends with #{friend.email}."
    else
      current_user.friend_request(friend)
      redirect_to users_path, notice: "Friend request sent to #{friend.email}."
    end
  end

  def friend_requests
    @friend_requests = current_user.received_friend_requests.pending
  end

  def accept_friend_request
    friendship = current_user.received_friend_requests.find(params[:id])
    if friendship&.pending?
      friendship.accepted!
      Friendship.create(user: current_user, friend: friendship.user, status: 'accepted')
      redirect_to users_path, notice: 'Friend request accepted.'
    else
      redirect_to users_path, alert: 'Invalid friend request.'
    end
  end

  def reject_friend_request
    friendship = current_user.received_friend_requests.find(params[:id])
    friendship.rejected!
    redirect_to users_path, notice: 'Friend request rejected.'
  end

  def accepted_friends
    @friends = current_user.friends
  end

  private

  helper_method :user_has_pending_request?, :user_already_friends?

  def user_has_pending_request?(user)
    current_user.sent_friend_requests.exists?(friend: user, status: 'pending')
  end

  def user_already_friends?(user)
    current_user.friends.include?(user) || current_user.received_friend_requests.exists?(user: user, status: 'accepted')
  end
end
