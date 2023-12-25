class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :address, :string
    add_column :users, :dob, :date
    add_column :users, :skills, :string
    add_column :users, :programming_languages, :string
  end
end
