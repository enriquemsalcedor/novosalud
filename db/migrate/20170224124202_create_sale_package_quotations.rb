class CreateSalePackageQuotations < ActiveRecord::Migration[5.0]
  def change
    create_table :sale_package_quotations do |t|
      t.integer :quantity
      t.references :colection_package, foreign_key: true
      t.references :sale_quotation, foreign_key: true
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
