class AddTemporyPasswordToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :temporary_password, :boolean
    add_column :users, :temporary_password_valid, :boolean
  end
end
