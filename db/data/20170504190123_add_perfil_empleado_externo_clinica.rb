class AddPerfilEmpleadoExternoClinica < SeedMigration::Migration
  def up
    [
      {name: "Analista clínica",security_role_id: 2}
    ].each do |security_profile|
       Security::Profile.create(security_profile)
      end
  end

  def down
    Security::Profile.destroy.all
  end
end
