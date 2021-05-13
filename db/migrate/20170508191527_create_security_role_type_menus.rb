class CreateSecurityRoleTypeMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :security_role_type_menus do |t|
      t.references :security_role_type, foreign_key: true
      t.references :security_role_menu, foreign_key: true

      t.timestamps
    end
  end
end
