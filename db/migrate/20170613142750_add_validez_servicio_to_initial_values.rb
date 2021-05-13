class AddValidezServicioToInitialValues < ActiveRecord::Migration[5.0]
  def change
    add_column :initial_values, :days_validity_service, :integer
  end
end
