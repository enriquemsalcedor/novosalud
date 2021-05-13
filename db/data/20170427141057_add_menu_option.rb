class AddMenuOption < SeedMigration::Migration
  def up
    Security::Menu.create!([
      { description: 'Activación producto',codemenu: '<a href="#">Activación producto</a>', is_father: true, controller: '' },
      { description: 'Caja',codemenu: '<a href="">Caja</a>', is_father: true, controller: ''},
      { description: 'Centro Médico',codemenu: '<a href="/clinic/clinic_service">Centro Médico</a>', is_father: true, controller: 'clinic/clinic_services' },
      { description: 'Configuración',codemenu: '<a href="">Configuración</a>', is_father: true, controller: ''}
    ])

    menupadre = Security::Menu.find_by description: 'Activación producto'
    Security::Menu.create!([
      { description: 'Productos Pagados', codemenu: '<a href="/payment/contracted_products">Productos Pagados</a>', menu_id: menupadre.id , controller: 'payment/contracted_products'},
      { description: 'Activar Producto', codemenu: '<a href="/service/services/new">Activar Producto</a>', menu_id: menupadre.id , controller: 'service/services'},
      { description: 'Servicios', codemenu: '<a href="/service/services">Servicios</a>', menu_id: menupadre.id , controller: 'service/services',action: true},
      { description: 'Servicios Activados', codemenu: '<a href="/service/reports">Servicios Activados</a>', menu_id: menupadre.id , controller: 'service/services'}
    ])

    menupadre = Security::Menu.find_by description: 'Caja'
    Security::Menu.create!([
      { description: 'Cotizaciones', codemenu: '<a href="/sale/quotations">Cotizaciones</a>', menu_id: menupadre.id , controller: 'sale/quotations', action: true},
      { description: 'Planes', codemenu: '<a href="/payment/plans">Planes</a>', menu_id: menupadre.id , controller: 'payment/plans'},
      { description: 'Cierre de Caja', codemenu: '<a href="/payment/plans_cierre">Cierre de Caja</a>', menu_id: menupadre.id , controller: 'payment/plans'}
    ])

    menupadre = Security::Menu.find_by description: 'Configuración'
    Security::Menu.create!([
      { description: 'Proveedor', codemenu: '<a href="">Proveedor</a>', menu_id: menupadre.id, is_father: true, controller: ''},
      { description: 'Producto', codemenu: '<a href="">Producto</a>', menu_id: menupadre.id, is_father: true, controller: '' },
      { description: 'Paquete o promociones', codemenu: '<a href="/colection/packages">Paquete ó promociones</a>', menu_id: menupadre.id , controller: 'colection/packages'},
      { description: 'Bancos', codemenu: '<a href="/banks">Bancos</a>', menu_id: menupadre.id , controller: 'banks'},
      { description: 'Modalidad de pago', codemenu: '<a href="/method_payments">Modalidad de pago</a>', menu_id: menupadre.id , controller: 'method_payments'},
      { description: 'Organización', codemenu: '<a href="/organizations/1">Organización</a>', menu_id: menupadre.id , controller: 'organizations'},
      { description: 'Valores iniciales', codemenu: '<a href="/initial_values/1">Valores iniciales</a>', menu_id: menupadre.id , controller: 'initial_values'},
      { description: 'Motivo', codemenu: '<a href="/motives">Motivo</a>', menu_id: menupadre.id , controller: 'motives'},
      { description: 'Registro', codemenu: '<a href="">Registro</a>', menu_id: menupadre.id , is_father: true, controller: ''},
      { description: 'Vigencia por Cotización', codemenu: '<a href="/sale/reactivar">Vigencia por Cotización</a>', menu_id: menupadre.id, controller:'sale/quotations' }
    ])

    menupadre = Security::Menu.find_by description: 'Proveedor'
    Security::Menu.create!([
      { description: 'Especialidad', codemenu: '<a href="/specialities">Especialidad</a>', menu_id: menupadre.id , controller: 'specialities'},
      { description: 'Tipo de proveedor', codemenu: '<a href="/provider/provider_types">Tipo de proveedor</a>', menu_id: menupadre.id , controller: 'provider/provider_types'},
      { description: 'Proveedores', codemenu: '<a href="/provider/providers">Proveedor</a>', menu_id: menupadre.id , controller: 'provider/providers'},
      { description: 'Médico', codemenu: '<a href="/provider/medicos">Médico</a>', menu_id: menupadre.id , controller: 'provider/medicos'}
    ])

    menupadre = Security::Menu.find_by description: 'Producto'
    Security::Menu.create!([
      { description: 'Tipo de producto</a>', codemenu: '<a href="/product/product_types">Tipo de producto</a>', menu_id: menupadre.id , controller: 'product/product_types'},
      { description: 'Productos', codemenu: '<a href="/product/products">Producto</a>', menu_id: menupadre.id , controller: 'product/products'}
    ])

    menupadre = Security::Menu.find_by description: 'Registro'
    Security::Menu.create!([
      { description: 'Perfil empleado', codemenu: '<a href="/security/profiles">Perfil empleado</a>', menu_id: menupadre.id , controller: 'security/profiles'},
      { description: 'Cargo', codemenu: '<a href="/positions/">Cargo</a>', menu_id: menupadre.id , controller: 'positions'},
      { description: 'Registrar empleado interno', codemenu: '<%= link_to "Registrar empleado interno", employees_path(:empleado => "interno") %>', menu_id: menupadre.id , controller: 'employees'},
      { description: 'Registrar empleados externo', codemenu: '<%= link_to "Registrar empleados externo", employees_path(:empleado => "externo") %>', menu_id: menupadre.id , controller: 'employees'},
      { description: 'Cuentas de usuarios bloqueados', codemenu: '<%= link_to "Cuentas de usuarios bloqueados", blocked_user_path %>', menu_id: menupadre.id , controller: 'employees'}
    ])

  end

  def down
     Security::Menu.destroy_all
  end
end
