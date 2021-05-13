class CreateProviderMedicoProviders < ActiveRecord::Migration[5.0]
  def change
    create_table :provider_medico_providers do |t|
      t.references :provider_provider, foreign_key: true
      t.references :provider_medico, foreign_key: true
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
