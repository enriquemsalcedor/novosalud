class AddControllerCitasPorAgendar < SeedMigration::Migration
  def up
  	opcionmenu= Security::Menu.find_by id: 38
    opcionmenu.update(controller: 'clinic/clinic_service')
    opcionmenu.update(action: true)


  end

  def down

  end
end
