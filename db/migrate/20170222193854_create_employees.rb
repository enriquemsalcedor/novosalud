class CreateEmployees < ActiveRecord::Migration[5.0]
  def change
    create_table :employees do |t|
      t.string :second_name, limit: 50
      t.string :second_surname, limit: 50
      t.string :code_employee, limit: 20
      t.string :motive, limit: 150
      t.string :status, limit: 15, default: "Inactivo"
      t.boolean :confirmed, default: false
      t.integer :provider_provider_id
      t.references :position, foreign_key: true
      t.references :security_profiles, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
