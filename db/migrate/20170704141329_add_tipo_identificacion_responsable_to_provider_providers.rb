class AddTipoIdentificacionResponsableToProviderProviders < ActiveRecord::Migration[5.0]
  def change
    add_column :provider_providers, :type_identification_responsable, :string, limit: 1
  end
end
