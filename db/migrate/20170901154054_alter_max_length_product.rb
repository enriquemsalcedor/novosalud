class AlterMaxLengthProduct < ActiveRecord::Migration[5.0]
    change_table :product_products do |p|
      p.change :description,:string , limit: 400
      p.change :terms ,:string , limit: 400
    end
end
