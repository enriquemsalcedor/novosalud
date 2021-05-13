class ActualizacionNombres < SeedMigration::Migration
  def up
  	menuusuario = Security::Menu.find_by description: 'Usuario clínica'
    menuusuario.update(description: "Usuario Prestador de Servicio",codemenu: '<%= link_to "Usuario Prestador de Servicio", employees_path(:empleado => "externo") %>')

    menuactivarproducto = Security::Menu.find_by description: 'Activar Producto'
    menuactivarproducto.update(description: "Activar Servicio",codemenu: '<a href="/service/services/new">Activar Servicio</a>')

    menuproovedor = Security::Menu.find_by description: 'Centro Médico'
    menuproovedor.update(description: "Proveedor de Servicio",codemenu: '<a href="/clinic/clinic_service">Proveedor de Servicio</a>')

  end
  def down
  	menuusuario = Security::Menu.find_by description: 'Usuario Prestador de Servicio'
    menuusuario.update(description: "Usuario clínica",codemenu: '<%= link_to "Usuario clínica", employees_path(:empleado => "externo") %>')

    menuactivarproducto = Security::Menu.find_by description: 'Activar Servicio'
    menuactivarproducto.update(description: "Activar Producto",codemenu: '<a href="/service/services/new">Activar Producto</a>')

    menuproovedor = Security::Menu.find_by description: 'Proveedor de Servicio'
    menuproovedor.update(description: "Centro Médico",codemenu: '<a href="/clinic/clinic_service">Centro Médico</a>')

  end
end
