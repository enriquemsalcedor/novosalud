class AddAtributoPlanToPaymentPlans < ActiveRecord::Migration[5.0]
  def change
    add_column :payment_plans, :bank_id, :integer
    add_column :payment_plans, :reference, :string , limit: 15
  end
end
