class CreateBanks < ActiveRecord::Migration[5.0]
  def change
    create_table :banks do |t|
      t.string :name, limit: 50
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
