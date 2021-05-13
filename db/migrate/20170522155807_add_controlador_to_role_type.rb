class AddControladorToRoleType < ActiveRecord::Migration[5.0]
  def change
    add_column :security_role_types, :controller, :string
    add_column :security_role_types, :action, :boolean, default: false
    add_column :security_menus, :action, :boolean, default: false
  end
end
