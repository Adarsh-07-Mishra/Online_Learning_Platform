# frozen_string_literal: true

# app/models/message.rb
class Message < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  has_one_attached :attachment

  def broadcast
    ActionCable.server.broadcast('message_channel', {
                                   content: content,
                                   user_email: user.email,
                                   attachment_url: attachment_url
                                 })
  end

  def attachment_url
    return unless attachment.attached?

    Rails.application.routes.url_helpers.rails_blob_path(attachment.variant(resize: '100x100'), only_path: true)
  end
end
