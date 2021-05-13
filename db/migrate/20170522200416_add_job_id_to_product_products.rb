class AddJobIdToProductProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :product_products, :job_id, :integer
  end
end
