class MessagesController < ApplicationController
    before_action :authenticate_user!
  
    def create
      friend = User.find(params[:friend_id])
      message = current_user.messages.create(friend: friend, content: params[:content])
      redirect_to user_messages_path(current_user, friend), notice: 'Message sent!'
    end
  end