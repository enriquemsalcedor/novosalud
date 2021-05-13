class CreateMotiveProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :motive_profiles do |t|
      t.string :motive
      t.integer :profile_id
      t.string :status
      t.integer :user_created_id

      t.timestamps
    end
  end
end
