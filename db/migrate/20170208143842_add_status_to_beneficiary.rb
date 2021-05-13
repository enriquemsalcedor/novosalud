class AddStatusToBeneficiary < ActiveRecord::Migration[5.0]
  def change
    add_column :beneficiaries, :status, :string, limit: 15, default: "Activo"
  end
end
