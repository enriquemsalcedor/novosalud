class AddEmailToAccount < ActiveRecord::Migration[5.0]
  def change
    add_column :accounts, :email, :string, limit: 60
  end
end
