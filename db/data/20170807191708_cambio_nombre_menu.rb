class CambioNombreMenu < SeedMigration::Migration
  def up
  	menupadre = Security::Menu.find_by(description: "Activación producto")
    menupadre.update(description: "Activación de servicio", codemenu: '<a href="#">Activación de servicio</a>' )

    menuhijo = Security::Menu.find_by description: 'Registrar empleados externo'
    menuhijo.update(description: "Usuario clínica",codemenu: '<%= link_to "Usuario clínica", employees_path(:empleado => "externo") %>')

    menuhijo1 = Security::Menu.find_by description: 'Registrar empleado interno'
    menuhijo1.update(description: "Registrar empleado",codemenu: '<%= link_to "Registrar empleado", employees_path(:empleado => "interno") %>')
  end

  def down
  	menupadre = Security::Menu.find_by(description: "Activación de servicio")
    menupadre.update(description: "Activación producto", codemenu: '<a href="#">Activación producto</a>' )

    menuhijo = Security::Menu.find_by description: 'Usuario clínica'
    menuhijo.update(description: "Registrar empleados externo",codemenu: '<%= link_to "Registrar empleados externo", employees_path(:empleado => "externo") %>')

    menuhijo1 = Security::Menu.find_by description: 'Registrar empleado'
    menuhijo1.update(description: "Registrar empleado interno",codemenu: '<%= link_to "Registrar empleados interno", employees_path(:empleado => "interno") %>')
  end
end
