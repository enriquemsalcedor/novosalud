class AddDirectionWebToBanks < ActiveRecord::Migration[5.0]
  def change
    add_column :banks, :direction_web, :string
  end
end
