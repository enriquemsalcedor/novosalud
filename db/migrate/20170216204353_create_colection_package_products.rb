class CreateColectionPackageProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :colection_package_products do |t|
      t.integer :quantity
      t.references :product_product, foreign_key: true
      t.references :colection_package, foreign_key: true
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
