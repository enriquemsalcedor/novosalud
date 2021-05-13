class CreateProviderProviders < ActiveRecord::Migration[5.0]
  def change
    create_table :provider_providers do |t|
      t.integer :clinic_code
      t.string :name, limit: 50
      t.string :type_identification, limit: 1
      t.string :rif, limit: 15
      t.string :phone, limit: 15
      t.string :email, limit: 50
      t.string :address,  limit: 140 
      t.integer :identification_document
      t.string :firt_name_responsable, limit: 50
      t.string :last_name_responsable, limit: 50
      t.string :phone_responsable, limit: 15
      t.string :position, limit: 50
      t.string :email_responsable, limit: 60
      t.references :territory_country, foreign_key: true
      t.references :territory_state, foreign_key: true
      t.references :territory_city, foreign_key: true
      t.references :provider_provider_type, foreign_key: true
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
