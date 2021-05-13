class AddPhonesToProviderProviders < ActiveRecord::Migration[5.0]
  def change
    add_column :provider_providers, :phone2, :string, :limit => 15
    add_column :provider_providers, :phone3, :string, :limit => 15
  end
end
