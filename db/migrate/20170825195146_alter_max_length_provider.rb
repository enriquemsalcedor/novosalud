class AlterMaxLengthProvider < ActiveRecord::Migration[5.0]
  def change
    change_table :provider_providers do |p|
      p.change :name,:string , limit: 200
    end
  end
end
