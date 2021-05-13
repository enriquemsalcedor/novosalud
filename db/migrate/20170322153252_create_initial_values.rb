class CreateInitialValues < ActiveRecord::Migration[5.0]
  def change
    create_table :initial_values do |t|
      t.integer :days_validity
      t.integer :max_refech_service
      t.integer :number_employee
      t.integer :max_quantity_product
      t.string  :email_max_quantity, limit: 50
      t.string  :email_security, limit: 50
      t.integer :user_created_id
      t.integer :user_updated_id
      t.timestamps
    end
  end
end
