class AddActualizacionPerfil < SeedMigration::Migration
  def up
      perfil = Security::Profile.find_by(name: "Administrador")
      perfil.update(security_role_id: 5)
  end

  def down

  end
end
