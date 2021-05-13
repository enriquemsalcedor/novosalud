class CambioLabelMenuPaquete < SeedMigration::Migration
  def up
    @menu = Security::Menu.find_by(description: "Paquete o promociones")

    @menu.update(description: 'Paquetes o promociones', codemenu: '<a href="/colection/packages">Paquetes o promociones</a>' )

  end

  def down

  end
end
