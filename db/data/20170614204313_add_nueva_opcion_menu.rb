class AddNuevaOpcionMenu < SeedMigration::Migration

  def up
    menupadre = Security::Menu.find_by description: 'Centro Médico'
    Security::Menu.create!([
      { description: 'Citas por Agendar', codemenu: '<a href="/clinic/pending_date">Citas por Agendar</a>', menu_id: menupadre.id },
    ])
  end

  def down
    Security::Menu.destroy.all
  end
end
