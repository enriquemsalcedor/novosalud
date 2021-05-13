class AddControladorToSecurityMenus < ActiveRecord::Migration[5.0]
  def change
    add_column :security_menus, :controller, :string
  end
end
