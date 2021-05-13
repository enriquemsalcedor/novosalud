class CreateTerritoryCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :territory_countries do |t|
      t.string :name, limit: 50

      t.timestamps
    end
  end
end
