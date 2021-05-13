class AlterProductMaxLength < ActiveRecord::Migration[5.0]
    change_table :product_products do |p|
      p.change :description,:string , limit: 700
      p.change :terms ,:string , limit: 700
    end
end
