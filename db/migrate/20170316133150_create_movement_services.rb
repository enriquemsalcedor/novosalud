class CreateMovementServices < ActiveRecord::Migration[5.0]
  def change
    create_table :movement_services do |t|
      t.string :code, limit: 15
      t.date :date_service
      t.date :appointment_date
      t.integer :service_service_id
      t.integer :beneficiary_id
      t.integer :payment_contracted_product_id
      t.integer :provider_medico_provider_id
      t.integer :motive_id
      t.string :status, limit: 15
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
