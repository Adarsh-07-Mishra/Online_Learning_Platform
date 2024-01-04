# # app/channels/chat_channel.rb
# class ChatChannel < ApplicationCable::Channel
#   def subscribed
#     stream_for current_user
#   end

#   def receive(data)
#     friend_id = data['friend_id']
#     content = data['content']
#     event_type = data['event_type']

#     if event_type == 'friend_request_sent'
#       # Handle friend request sent event
#       broadcast_to current_user, event: 'friend_request_sent', friend_id: friend_id
#     elsif event_type == 'friend_request_received'
#       # Handle friend request received event
#       broadcast_to current_user, event: 'friend_request_received', friend_id: friend_id
#     elsif event_type == 'message_sent'
#       # Handle message sent event
#       broadcast_to current_user, event: 'message_sent', friend_id: friend_id, content: content
#     elsif event_type == 'message_received'
#       # Handle message received event
#       friend = User.find(friend_id)
#       broadcast_to friend, event: 'message_received', friend_id: current_user.id, content: content
#     end
#   end

#   def unsubscribed
#     # Any cleanup needed when channel is unsubscribed
#   end
# end



# app/channels/chat_channel.rb
class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_#{current_user.id}"
  end

  def receive(data)
    friend_id = data['friend_id']
    content = data['content']
    event_type = data['event_type']

    if event_type == 'friend_request_sent'
      # Handle friend request sent event
      broadcast_to_user(current_user, 'friend_request_sent', friend_id)
    elsif event_type == 'friend_request_received'
      # Handle friend request received event
      broadcast_to_user(current_user, 'friend_request_received', friend_id)
    elsif event_type == 'message_sent'
      # Handle message sent event
      broadcast_to_user(current_user, 'message_sent', friend_id, content)
      broadcast_to_user(User.find(friend_id), 'message_received', current_user.id, content)
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def broadcast_to_user(user, event, *args)
    ActionCable.server.broadcast("user_#{user.id}", event: event, *args)
  end
end
