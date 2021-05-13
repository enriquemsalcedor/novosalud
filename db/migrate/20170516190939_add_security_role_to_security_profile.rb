class AddSecurityRoleToSecurityProfile < ActiveRecord::Migration[5.0]
  def change
    add_reference :security_profiles, :security_role, foreign_key: true
  end
end
