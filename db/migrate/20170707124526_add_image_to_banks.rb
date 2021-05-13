class AddImageToBanks < ActiveRecord::Migration[5.0]
  def change
    add_attachment :banks, :image
  end
end
