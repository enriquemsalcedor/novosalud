class NuevoPermiso < SeedMigration::Migration
  def up
    [
      {name: "Desbloquear Usuario"},
      {name: "Reenviar Usuario"},
      {name: "Reenviar Contraseña"}

    ].each do |security_role_type|
      Security::RoleType.create(security_role_type)
    end
  end

  def down
    Security::RoleType.destroy.all
  end
end
