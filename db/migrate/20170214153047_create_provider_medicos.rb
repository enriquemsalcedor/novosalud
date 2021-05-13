class CreateProviderMedicos < ActiveRecord::Migration[5.0]
  def change
    create_table :provider_medicos do |t|
      t.string :code_medico, limit: 20
      t.references :people, foreign_key: true
      t.references :speciality, foreign_key: true
      t.string :status, limit: 15, default: "Activo"
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
