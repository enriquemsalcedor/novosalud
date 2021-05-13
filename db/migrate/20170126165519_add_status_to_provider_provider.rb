class AddStatusToProviderProvider < ActiveRecord::Migration[5.0]
  def change
    add_column :provider_providers, :status, :string, limit: 15, default: "Activo"
  end
end
