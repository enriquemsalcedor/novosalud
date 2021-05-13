class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.string :name, limit: 50
      t.string :rif, limit: 15
      t.string :email, limit: 60
      t.string :address, limit: 140
      t.string :phone, limit: 18
      t.integer :user_updated_id

      t.timestamps
    end
  end
end

