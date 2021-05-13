class CreateTerritoryCities < ActiveRecord::Migration[5.0]
  def change
    create_table :territory_cities do |t|
      t.string :name, limit: 50
      t.references :territory_state, foreign_key: true

      t.timestamps
    end
  end
end

