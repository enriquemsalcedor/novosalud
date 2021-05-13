class AddStatusToProviderProviderType < ActiveRecord::Migration[5.0]
  def change
    add_column :provider_provider_types, :status, :string, limit: 15, default: "Activo"
  end
end
