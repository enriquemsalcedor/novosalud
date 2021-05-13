class AddRoleMenuEmpleadoExterno < SeedMigration::Migration
  def up

    [
      { security_menu_id: 3, security_role_id: 2, created_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M"), updated_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M") },
      { security_menu_id: 25, security_role_id: 2, created_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M"), updated_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M") },
      { security_menu_id: 32, security_role_id: 5, created_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M"), updated_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M") },
      { security_menu_id: 33, security_role_id: 5, created_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M"), updated_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M") },
      { security_menu_id: 34, security_role_id: 5, created_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M"), updated_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M") },
      { security_menu_id: 35, security_role_id: 5, created_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M"), updated_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M") }
    ].each do |security_role_menu|
       Security::RoleMenu.create(security_role_menu)
      end
  end

  def down
    Security::RoleMenu.destroy.all
  end
end