class CreateSecurityRoleMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :security_role_menus do |t|
      t.references :security_role, foreign_key: true
      t.references :security_menu, foreign_key: true

      t.timestamps
    end
  end
end
