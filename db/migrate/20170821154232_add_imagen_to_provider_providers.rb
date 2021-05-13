class AddImagenToProviderProviders < ActiveRecord::Migration[5.0]
  def change
    add_attachment :provider_providers, :image
  end
end
