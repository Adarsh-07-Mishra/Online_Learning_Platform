# app/models/message.rb

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id', optional: true

  def broadcast
    ActionCable.server.broadcast('message_channel', content: content, user_email: user.email)
  end

  # scope :unread, -> { where(read: false) }
  # scope :from_user, ->(user) { where(user: user) }

  # after_initialize :set_default_values

  # private

  # def set_default_values
  #   self.read ||= false
  # end
end
