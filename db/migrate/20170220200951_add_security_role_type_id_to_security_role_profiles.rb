class AddSecurityRoleTypeIdToSecurityRoleProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :security_role_profiles, :security_role_type_id, :integer
  end
end
