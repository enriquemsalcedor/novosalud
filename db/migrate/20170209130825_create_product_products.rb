class CreateProductProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :product_products do |t|
      t.string :code,limit: 20
      t.string :name, limit: 50
      t.string :category, limit: 15
      t.string :terms, limit: 200
      t.date :publication_date
      t.date :expiration_date
      t.string :status, limit: 15
      t.integer :speciality_id
      t.integer :product_product_type_id
      t.float :price
      t.integer :provider_provider_id
      t.integer :user_created_id
      t.integer :user_updated_id
      t.timestamps
    end
  end
end
