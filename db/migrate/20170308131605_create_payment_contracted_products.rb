class CreatePaymentContractedProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_contracted_products do |t|
      t.string :code, limit: 15
      t.float :price_contracted
      t.integer :plan_id
      t.integer :product_product_id
      t.string :status, limit: 15
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
