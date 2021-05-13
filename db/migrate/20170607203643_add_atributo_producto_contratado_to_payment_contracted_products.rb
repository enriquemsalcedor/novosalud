class AddAtributoProductoContratadoToPaymentContractedProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :payment_contracted_products, :valid_until, :date
    add_column :payment_contracted_products, :job_id, :integer
    add_column :payment_contracted_products, :payment_contracted_package_id, :integer
  end
end
