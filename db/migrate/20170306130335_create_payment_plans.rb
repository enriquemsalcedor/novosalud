class CreatePaymentPlans < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_plans do |t|
      t.string :number_plan , limit: 10
      t.integer :customer_id
      t.integer :company_id
      t.integer :sale_quotation_id
      t.integer :method_payment_id
      t.string :status, limit: 15
      t.float :total_amount
      t.integer :user_created_id
      t.integer :user_updated_id
      
      t.timestamps
    end
  end
end
