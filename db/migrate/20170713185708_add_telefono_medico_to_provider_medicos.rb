class AddTelefonoMedicoToProviderMedicos < ActiveRecord::Migration[5.0]
  def change
    add_column :provider_medicos, :phone_medico, :string,limit: 15
  end
end
