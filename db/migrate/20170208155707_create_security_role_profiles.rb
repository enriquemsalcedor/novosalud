class CreateSecurityRoleProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :security_role_profiles do |t|
      t.date :start_date
      t.date :end_date
      t.references :security_profile, foreign_key: true
      t.references :security_role, foreign_key: true
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
