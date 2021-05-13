class CreateColectionPackages < ActiveRecord::Migration[5.0]
  def change
    create_table :colection_packages do |t|
      t.string :code, limit: 20
      t.string :description, limit: 140
      t.date :valid_since
      t.date :valid_until
      t.float :total_amount
      t.string :category, limit: 15
      t.string :terms, limit: 200
      t.string :status, limit: 15, default: "Inactivo"
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
