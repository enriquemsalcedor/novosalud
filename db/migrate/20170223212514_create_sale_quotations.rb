class CreateSaleQuotations < ActiveRecord::Migration[5.0]
  def change
    create_table :sale_quotations do |t|
      t.string :quoting_number
      t.string :status, limit: 15, default: "En_cotizacion"
      t.integer :user_id
      t.date :valid_since
      t.date :valid_until
      t.integer :user_created_id
      t.integer :user_updated_id
      t.inet :ip_quotation

    t.timestamps
    end 
  end
end
