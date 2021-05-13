class CambioMenuUsuariosBloqueados < SeedMigration::Migration
  def up
    @menu = Security::Menu.find_by(description: "Cuentas de usuarios bloqueados")
    @menu.update(codemenu: '<%= link_to "Cuentas de usuarios bloqueados", blocked_user_path %>' )
  end

  def down
    @menu = Security::Menu.find_by(description: "Cuentas de usuarios bloqueados")
    @menu.update(codemenu: '<a href="/product/products">Cuentas de usuarios bloqueados</a>' )
  end
end
