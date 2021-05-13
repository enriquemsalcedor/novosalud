class AddModificacionMenu < SeedMigration::Migration
  def up
  	menupadre = Security::Menu.find_by description: 'Centro Médico'
    Security::Menu.create!([
      { description: 'Citas Agendadas', codemenu: '<a href="/clinic/clinic_service">Citas Agendadas</a>', menu_id: menupadre.id, controller: 'clinic/clinic_service',action: true},
      { description: 'Beneficiarios Atendidos', codemenu: '<a href="/clinic/reports">Beneficiarios Atendidos</a>', menu_id: menupadre.id, controller: 'clinic/clinic_service'}
    ])

    menupadre = Security::Menu.find_by description: 'Registro'
    Security::Menu.create!([
      { description: 'Roles/Menú', codemenu: '<a href="/security/roles">Roles/Menú</a>', menu_id: menupadre.id, controller: 'security/roles'}
    ])
  end

  def down
  	Security::Menu.destroy.all
  end
end
