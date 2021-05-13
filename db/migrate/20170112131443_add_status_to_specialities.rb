class AddStatusToSpecialities < ActiveRecord::Migration[5.0]
  def change
    add_column :specialities, :status, :string, limit: 15, default: "Activo"
  end
end
