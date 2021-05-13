class CreateSecurityMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :security_menus do |t|
      t.string :description, limit: 30
      t.string :codemenu, limit: 255
      t.integer :menu_id
      t.boolean :is_father, default: false

      t.timestamps
    end
  end
end
