# frozen_string_literal: true

# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    friend = User.find(params[:message][:receiver_id])
    @message = current_user.messages.new(message_params)
    @message.friend = friend

    if @message.save
      attachment_url = @message.attachment.present? ? url_for(@message.attachment.variant(resize: '100x100')) : nil

      ActionCable.server.broadcast('message_channel', {
                                     event: 'message_sent',
                                     friend_id: friend.id,
                                     content: @message.content,
                                     attachment_url: attachment_url
                                   })

      ActionCable.server.broadcast("message_channel_#{friend.id}", {
                                     event: 'message_received',
                                     friend_id: current_user.id,
                                     content: @message.content,
                                     attachment_url: attachment_url
                                   })

      redirect_to new_message_path(receiver_id: friend.id), notice: 'Message sent!'
    else
      flash.now[:alert] = 'Error sending message!'
      @chat_messages = current_user.chat_messages_with(friend).order(created_at: :asc)
      render 'new'
    end
  end

  def new
    @message = Message.new
    @receiver = User.find(params[:receiver_id])
    @chat_messages = current_user.chat_messages_with(@receiver).order(created_at: :asc)
  end

  def reply
    @message = Message.new(message_params)
    @receiver = User.find(params[:message][:receiver_id])

    if @message.save
      redirect_to new_message_path(receiver_id: @receiver.id), notice: 'Reply sent!'
    else
      # Handle errors
      render :reply
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :receiver_id, :attachment)
  end
end
