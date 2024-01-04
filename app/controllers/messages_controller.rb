# app/controllers/messages_controller.rb
class MessagesController < ApplicationController
  before_action :authenticate_user!

  # def create
  #   friend = User.find(params[:message][:receiver_id])
  #   message = current_user.messages.create(friend: friend, content: params[:message][:content])
  #   ChatChannel.broadcast_to(current_user, event: 'message_sent', friend_id: friend.id, content: params[:message][:content])
  #   ChatChannel.broadcast_to(friend, event: 'message_received', friend_id: current_user.id, content: params[:message][:content])
  #   redirect_to new_message_path(receiver_id: friend.id), notice: 'Message sent!'
  # end

  def create
    friend = User.find(params[:message][:receiver_id])
    @message = current_user.messages.create(friend: friend, content: params[:message][:content], read: false)

    if @message.valid?
      ActionCable.server.broadcast('message_channel',
                                   { event: 'message_sent', friend_id: friend.id, content: params[:message][:content] })
      ActionCable.server.broadcast("message_channel_#{friend.id}",
                                   { event: 'message_received', friend_id: current_user.id,
                                     content: params[:message][:content] })

      redirect_to new_message_path(receiver_id: friend.id), notice: 'Message sent!'
    else
      respond_to do |format|
        format.js { render 'error.js.erb' } # Add this line to render JavaScript template for errors
        format.html { redirect_to new_message_path(receiver_id: friend.id), alert: 'Error sending message!' }
      end
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

  # def received_messages
  #   @received_messages = current_user.received_messages
  # end

  private

  def message_params
    params.require(:message).permit(:content, :receiver_id)
  end
end
