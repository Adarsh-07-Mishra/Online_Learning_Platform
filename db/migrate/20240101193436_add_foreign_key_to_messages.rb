# frozen_string_literal: true

class AddForeignKeyToMessages < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :messages, :users, column: :friend_id
  end
end
