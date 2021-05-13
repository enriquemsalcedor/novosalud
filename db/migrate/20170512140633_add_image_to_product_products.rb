class AddImageToProductProducts < ActiveRecord::Migration[5.0]
  def change
    add_attachment :product_products, :image
  end
end
