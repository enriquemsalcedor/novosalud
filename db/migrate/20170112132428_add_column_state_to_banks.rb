class AddColumnStateToBanks < ActiveRecord::Migration[5.0]
  def change
    add_column :banks, :status, :string, limit: 15, default: "Activo"
  end
end
