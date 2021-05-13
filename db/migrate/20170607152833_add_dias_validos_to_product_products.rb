class AddDiasValidosToProductProducts < ActiveRecord::Migration[5.0]
  def change
    add_column :product_products, :valid_days, :integer
  end
end
