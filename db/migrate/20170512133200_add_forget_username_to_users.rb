class AddForgetUsernameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :forget_username, :boolean
  end
end
