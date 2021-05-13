class CreateSecurityProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :security_profiles do |t|
      t.string :name, limit: 50
      t.string :position, limit: 50
      t.string :status, limit: 15, default: "Activo"
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
