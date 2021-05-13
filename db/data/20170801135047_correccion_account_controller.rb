class CorreccionAccountController < SeedMigration::Migration
  def up
    opcionmenu = Security::Menu.find_by description: 'Cuentas Bancarias'
    opcionmenu.update(controller: 'accounts')
  end

  def down

  end
end
