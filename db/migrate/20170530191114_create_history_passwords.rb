class CreateHistoryPasswords < ActiveRecord::Migration[5.0]
  def change
    create_table :history_passwords do |t|
    	t.string :password, null: false
      t.references :user, foreign_key: true
      t.datetime :created_at

      t.timestamps
    end
  end
end
