class Security::RoleType < ApplicationRecord
  has_many :security_role_type_menus ,class_name: Security::RoleTypeMenu, foreign_key: :security_role_type_id
  
	aasm column: "status"  do 
    state  :Activo, initial: true
    state  :Inactivo

    event :habilitar do
      transitions from: :Inactivo, to: :Activo
    end

    event :inhabilitar do
      transitions from: :Activo, to: :Inactivo
    end
	end
  
   #Guarda el nombre con la primera letra de cada palabra en mayuscula
  def name=(s)
    write_attribute(:name, s.to_s.titleize) 
  end

  validates :name ,presence: true, uniqueness: true

  def self.perm(permiso,aux)
    case 

#permiso para citas agendadas
    when (permiso.params == "index" and permiso.controller == "clinic/clinic_service")
      aux2 = ["Atender"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
        where('name in (?) and action = true and controller = ?',aux2, permiso.controller)

#permiso para Beneficiarios Atendidos
    when (permiso.params == "report" and permiso.controller == "clinic/clinic_service")
      aux2 = ["Consultar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
        where('name in (?) and action = false and controller is null ', aux2)
      
#Permiso para Citas por agendar    
    when (permiso.params == "pending_date" and permiso.controller == "clinic/clinic_service")
      aux2 = ["Atender"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = true and controller = ?', aux2, permiso.controller)

#Permiso para producto pagados
    when (permiso.params == "index" and permiso.controller == "payment/contracted_products")
      aux2 = ["Consultar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso activacion servicio
    when (permiso.params == "new" and permiso.controller == "service/services")
      aux2 = ["Crear"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Servicios
    when (permiso.params == "index" and permiso.controller == "service/services")
      where('action = true and controller = ?', permiso.controller)

#Permiso para Servicios Activados
    when (permiso.params == "report_active" and permiso.controller == "clinic/clinic_service")
      aux2 = ["Consultar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Cotizaciones
    when (permiso.params == "index" and permiso.controller == "sale/quotations")
      aux2 = ["Consultar","Pagar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null',aux2)

#Permiso para Planes
    when (permiso.params == "index" and permiso.controller == "payment/plans")
      aux2 = ["Consultar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Cierre de caja
    when (permiso.params == "cierre" and permiso.controller == "payment/plans")
      aux2 = ["Consultar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Tipo producto
    when (permiso.params == "index" and permiso.controller == "product/product_types")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Producto
    when (permiso.params == "index" and permiso.controller == "product/products")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Bancos
    when (permiso.params == "index" and permiso.controller == "banks")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Metodos de pago
    when (permiso.params == "index" and permiso.controller == "method_payments")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Organizacion
    when (permiso.params == "show" and permiso.controller == "organizations")
      aux2 = ["Modificar","Consultar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Valores iniciales
    when (permiso.params == "show" and permiso.controller == "initial_values")
      aux2 = ["Modificar","Consultar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Motivos
    when (permiso.params == "index" and permiso.controller == "motives")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Perfil
    when (permiso.params == "index" and permiso.controller == "security/profiles")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Cargos
    when (permiso.params == "index" and permiso.controller == "positions")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Empleados y usuario clinica
    when (permiso.params == "index" and permiso.controller == "employees")
      aux2 = ["Consultar","Crear","Modificar","Activar","Eliminar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Usuarios bloqueados
    when (permiso.params == "blocked_user" and permiso.controller == "employees")
      aux2 = ["Consultar","Desbloquear Usuario"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Roles/Menú
    when (permiso.params == "index" and permiso.controller == "security/roles")
      aux2 = ["Crear","Modificar","Activar","Eliminar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)
      
#Permiso Recuperacion usuario
    when (permiso.params == "forget_username_list" and permiso.controller == "employees")
      aux2 = ["Consultar","Reenviar Usuario"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso Recuperacion contraseña
    when (permiso.params == "forget_password" and permiso.controller == "employees")
      aux2 =  ["Consultar","Reenviar Contraseña"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Vigencia por cotizacion
    when (permiso.params == "reactivate" and permiso.controller == "sale/quotations")
      aux2 = ["Consultar","Modificar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Especialidad
    when (permiso.params == "index" and permiso.controller == "specialities")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso Tipo de proveedor
    when (permiso.params == "index" and permiso.controller == "provider/provider_types")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Proveedor
    when (permiso.params == "index" and permiso.controller == "provider/providers")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Medicos
    when (permiso.params == "index" and permiso.controller == "provider/medicos")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#Permiso para Paquete o promociones
    when (permiso.params == "index" and permiso.controller == "colection/packages")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

#permiso para cuentas bancarias
    when (permiso.params == "index" and permiso.controller == "accounts")
      aux2 = ["Consultar","Crear","Modificar","Activar"]
      unless aux.empty?
        aux2 = aux2 - aux
      end
      where('name in (?) and action = false and controller is null ', aux2)

    else
      redirect_to()
    end
  end
end

