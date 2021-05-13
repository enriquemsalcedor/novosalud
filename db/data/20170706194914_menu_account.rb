class MenuAccount < SeedMigration::Migration
  def up
    menupadre = Security::Menu.find_by description: 'Configuración'
    Security::Menu.create!([
          { description: 'Cuentas Bancarias', codemenu: '<a href="/accounts">Cuentas Bancarias</a>', menu_id: menupadre.id },
        ])
  end

  def down
    Security::Menu.destroy.all
  end
end
