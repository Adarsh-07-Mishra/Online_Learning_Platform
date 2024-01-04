class AddFriendIdToMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :messages, :friend_id, :integer
  end
end
