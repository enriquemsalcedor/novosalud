class CreateProductProductTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :product_product_types do |t|
      t.string :name, limit: 50
      t.string :description, limit: 140
      t.string :status, limit: 15, default: "Activo"
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
