class AddUpdateIssues < SeedMigration::Migration
  def up
    perfil = Security::Profile.find_by(name: "Analista clínica")
    perfil.update(security_role_id: 2)

    menupadre = Security::Menu.find_by description: 'Centro Médico'
    menupadre.update(codemenu: '<a href="/clinic/clinic_service">Centro Médico</a>')
  end

  def down

  end
end
