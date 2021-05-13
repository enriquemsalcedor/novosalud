class CreatePaymentTransferences < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_transferences do |t|
      t.integer :bank_id
      t.integer :sale_quotation_id
      t.string :reference

      t.timestamps
    end
  end
end
