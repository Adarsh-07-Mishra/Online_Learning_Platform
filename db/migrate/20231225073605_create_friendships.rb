# db/migrate/xxx_create_friendships.rb
class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.references :user, foreign_key: true
      t.references :friend, foreign_key: { to_table: :users }
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
