class CreateServiceServices < ActiveRecord::Migration[5.0]
  def change
    create_table :service_services do |t|
      t.string :code, limit: 15
      t.date :date_service
      t.date :appointment_date
      t.references :beneficiary, foreign_key: true
      t.references :provider_medico_provider, foreign_key: true
      t.references :motive, foreign_key: true, null: true
      t.references :payment_contracted_product, foreign_key: true
      t.string :status, limit: 15
      t.string :observation, limit: 140 
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
