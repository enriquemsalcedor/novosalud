class AddNuevoRolePerfil < SeedMigration::Migration
  def up
    Security::RoleProfile.create! ([{
      security_profile_id: 5,
      security_role_id: 2,
      created_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M"),
      updated_at: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M"), 
      start_date: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M"),
      end_date: DateTime.strptime("05/14/2021 8:00", "%m/%d/%Y %H:%M"), 
      security_role_type_id: 1
      }])
  end

  def down
    Security::RoleProfile.destroy.all
  end
end
