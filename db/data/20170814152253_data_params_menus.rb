class DataParamsMenus < SeedMigration::Migration
  def up

    Security::Menu.where(description: "Activación de servicio").update(params: nil)
    Security::Menu.where(description: "Caja").update(params: nil)
    Security::Menu.where(description: "Proveedor de Servicio").update(params: nil)
    Security::Menu.where(description: "Configuración").update(params: nil)
    Security::Menu.where(description: "Productos Pagados").update(params: "index")
    Security::Menu.where(description: "Activar Servicio").update(params: "new")
    Security::Menu.where(description: "Servicios").update(params: "index")
    Security::Menu.where(description: "Servicios Activados").update(params: "report")
    Security::Menu.where(description: "Cotizaciones").update(params: "index")
    Security::Menu.where(description: "Planes").update(params: "index")
    Security::Menu.where(description: "Cierre de Caja").update(params: "cierre")
    Security::Menu.where(description: "Proveedor").update(params: nil)
    Security::Menu.where(description: "Producto").update(params: nil)
    Security::Menu.where(description: "Paquetes o promociones").update(params: "index")
    Security::Menu.where(description: "Bancos").update(params: "index")
    Security::Menu.where(description: "Modalidad de pago").update(params: "index")
    Security::Menu.where(description: "Organización").update(params: "show")
    Security::Menu.where(description: "Valores iniciales").update(params: "show")
    Security::Menu.where(description: "Motivo").update(params: "index")
    Security::Menu.where(description: "Registro").update(params: nil)
    Security::Menu.where(description: "Vigencia por Cotización").update(params: "reactivate")
    Security::Menu.where(description: "Especialidad").update(params: "index")
    Security::Menu.where(description: "Tipo de proveedor").update(params: "index")
    Security::Menu.where(description: "Proveedores").update(params: "index")
    Security::Menu.where(description: "Médico").update(params: "index")
    Security::Menu.where(description: "Tipo de producto</a>").update(params: "index")
    Security::Menu.where(description: "Productos").update(params: "index")
    Security::Menu.where(description: "Perfil empleado").update(params: "index")
    Security::Menu.where(description: "Cargo").update(params: "index")
    Security::Menu.where(description: "Registrar empleado").update(params: "index")
    Security::Menu.where(description: "Usuario Prestador de Servicio").update(params: "index")
    Security::Menu.where(description: "Cuentas de usuarios bloqueados").update(params: "blocked_user")
    Security::Menu.where(description: "Citas Agendadas").update(params: "index")
    Security::Menu.where(description: "Beneficiarios Atendidos").update(params: "report")
    Security::Menu.where(description: "Roles/Menú").update(params: "index")
    Security::Menu.where(description: "Recuperar Usuario").update(params: "forget_username_list",controller: "employees")
    Security::Menu.where(description: "Recuperar Contraseña").update(params: "forget_password",controller: "employees")
    Security::Menu.where(description: "Citas por Agendar").update(params: "pending_date")
    Security::Menu.where(description: "Cuentas Bancarias").update(params: "index")

  end

  def down

  end
end
