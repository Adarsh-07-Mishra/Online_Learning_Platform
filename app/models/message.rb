# app/models/message.rb

class Message < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
end
