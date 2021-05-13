class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.string :name, limit: 50
      t.string :email, limit: 50
      t.string :subject, limit: 50
      t.string :message, limit: 200

      t.timestamps
    end
  end
end
