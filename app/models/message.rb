# app/models/message.rb

class Message < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'
end
