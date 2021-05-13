class CreateBusinessCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :business_companies do |t|
      t.string :name, limit: 50
      t.string :type_identification, limit: 1
      t.string :rif, limit: 15
      t.string :email, limit: 60
      t.string :phone, limit: 15
      t.string :status, limit: 15, default: "Activo"
      t.integer :number_employee
      t.string :firt_name_responsable, limit: 50
      t.string :last_name_responsable, limit: 50
      t.string :address, limit: 140
      t.references :user, foreign_key: true
      t.references :business_company_type, foreign_key: true
      t.references :territory_country, foreign_key: true
      t.references :territory_state, foreign_key: true
      t.references :territory_city, foreign_key: true
      t.integer :user_created_id
      t.integer :user_updated_id
      t.timestamps
    end
  end
end

