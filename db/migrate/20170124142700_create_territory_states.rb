class CreateTerritoryStates < ActiveRecord::Migration[5.0]
  def change
    create_table :territory_states do |t|
      t.string :name, limit: 50
      t.references :territory_country, foreign_key: true

      t.timestamps
    end
  end
end
