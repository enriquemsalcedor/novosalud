class CreatePaymentContractedPackages < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_contracted_packages do |t|
      t.integer :colection_package_id
      t.integer :plan_id
      t.float :price_contracted
      t.string :status, limit: 15
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
