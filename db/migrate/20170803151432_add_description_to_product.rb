class AddDescriptionToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :product_products, :description, :text,limit: 250
  end
end
