class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.integer :bank_id
      t.string :account_number
      t.string :account_type
      t.string :status
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
