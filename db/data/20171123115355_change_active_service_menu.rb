class ChangeActiveServiceMenu < SeedMigration::Migration
  def up
    @active_service = Security::Menu.find_by(description: 'Servicios Activados')
    @active_service.update(controller: 'clinic/clinic_service', codemenu: '<a href="/clinic/report_active">Servicios Activados</a>')
  end

  def down
    @active_service = Security::Menu.find_by(description: 'Servicios Activados')
    @active_service.update(controller: 'service/services', codemenu: '<a href="/service/reports">Servicios Activados</a>')
  end
end
