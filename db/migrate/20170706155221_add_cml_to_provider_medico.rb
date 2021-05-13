class AddCmlToProviderMedico < ActiveRecord::Migration[5.0]
  def change
    add_column :provider_medicos, :c_m_l, :string, limit: 20
  end
end
