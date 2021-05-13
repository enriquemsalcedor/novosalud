class AddParamsToSecurityMenu < ActiveRecord::Migration[5.0]
  def change
    add_column :security_menus, :params, :string
  end
end
