class CreateFriends < ActiveRecord::Migration[7.1]
  def change
    create_table :friends do |t|
      t.references :user, foreign_key: true
      t.references :friend, foreign_key: { to_table: :users }
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :friends, %i[user_id friend_id], unique: true
  end
end
