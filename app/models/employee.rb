class Employee < ApplicationRecord
  belongs_to :security_profile, class_name: Security::Profile, foreign_key: :security_profiles_id, dependent: :destroy
  belongs_to :user, class_name: User,foreign_key: :user_id
  belongs_to :provider_provider, class_name: Business::Company, foreign_key: :provider_provider_id
  belongs_to :position, class_name: Position, foreign_key: :position_id
  VALID_NAME_REGEX = /\A[\p{L}\p{M}\'\ ]+\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  TYPE_IDENTIFICATION_OPTIONS = [ "V", "E","P" ]
  VALID_NUMBER_REGEX = /\A[0-9]*\z/ 
  TIPO_PERFIL_OPTIONS = [ "Temporal","Permanente" ]
  VALID_USERNAME_REGEX = /[\?\<\>\'\,\?\[\]\}\{\=\-\)\(\*\&\^\%\$\#\`\~\{\}\@]/

  aasm column: "status"  do
    state  :Activo
    state  :Inactivo, initial: true
    state  :Eliminado

    event :habilitar do
      transitions from: :Inactivo, to: :Activo,
                  after: [
                    :activar_usuario,
                  ]
    end

    event :inhabilitar do
      transitions from: :Activo, to: :Inactivo,
                  after: [
                    :inactivar_usuario, 
                  ]
    end

    event :eliminar_logico do
      transitions from: [:Activo,:Inactivo], to: :Eliminado,
                  after: [
                    :limpiar_correo_employee,
                  ]
    end

  end

  validates :email, uniqueness: {message:"Existe un registro con este correo electrónico."},
  format: { :with => VALID_EMAIL_REGEX , message: "El formato del correo electrónico es inválido." } ,
  :presence =>{:message =>"Por favor, introduzca correo electrónico."}
  validates :provider_provider_id, :presence =>{:message =>"Debe seleccionar una clinica."},
  :if => :es_clinica?
  validates :security_profiles_id, :presence =>{:message =>"Debe seleccionar un perfil."}, :if =>:es_novo?
  validates :position_id, :presence =>{:message =>"Debe seleccionar un cargo."}, :if =>:es_novo?
  validates_associated  :user
  validates :user, :presence =>{:message =>"No se pudo crear el usuario."}, on: [:update]
  validates :user, :uniqueness =>{:message =>"No se pudo crear el usuario."}
  validate :verificar_email_existente, on: [:create,:update]
  validate :verificar_existe_username, on:[:create, :update]
  validate :validar_usuario, on:[:create,:update]
  validates_format_of :second_name, :second_surname,:with => VALID_NAME_REGEX, message: "Solo se admite letras o el carácter especial (')" ,
    :allow_blank => true
  validates :identification_document, uniqueness: {message:"Existe un registro con esta cédula de identidad."},
  numericality: { only_integer: true },:presence => {:message =>"Por favor, introduzca cédula."},
  length: { in: 3..12 , message: "debe tener entre 3 y 12 caracteres."},
  format: {:with => VALID_NUMBER_REGEX, message: "Solo se admiten números." }
  validates :first_name, :presence =>{:message =>"Por favor, introduzca primer nombre."}, length: { maximum: 50 }, 
  format: {:with => VALID_NAME_REGEX, message: "Solo se admiten letras o el carácter especial (')" }
  validates :surname, :presence =>{:message =>"Por favor, introduzca apellido."}, length: { maximum: 50 },
  format: {:with => VALID_NAME_REGEX, message: "Solo se admiten letras o el carácter especial (')" }
  validates :type_identification, :presence =>{:message =>"Debe ingresar un tipo de identificación."}
  validates :date_valid, :presence =>{:message =>"Por favor, introduzca fecha válida para el perfil."}, if: "self.type_profile == 'Temporal'"
  validates_date :date_valid, :after => :today, :after_message => 'Debe ser mayor a la fecha de hoy.', if: "self.type_profile == 'Temporal'"

  #validates :usuario, format: {:with => VALID_USERNAME_REGEX, message: "Solo se admiten letras." }

  attr_accessor :usuario, :motive

  after_create :registrar_usuario

  def verificar_existe_username #valida si se asigno un usuario
    unless self.usuario == ""
      if asignar_username_con_opciones.nil? && self.usuario.nil?
        errors.add(:usuario, "Debe ingresar un usuario.")
        return false
      end
    else
      errors.add(:usuario, "Debe ingresar un usuario.")
      return false
    end  
  end

  def validar_usuario
    @user = User.find_by(username: self.usuario, client_type: "empleado")
    if @user.present? and @user.username != self.usuario
      errors.add(:usuario, "Existe un empleado con este usuario.")
      return false
    elsif self.usuario =~ /\d/ || self.usuario =~ VALID_USERNAME_REGEX
      errors.add(:usuario, "Solo se admiten letras.")
      return false
    end
  end
  
  def verificar_email_existente
    email_existe = User.find_by(email: self.email)
    if email_existe && self.user_id != email_existe.id
      errors.add(:email, "Existe un registro con este correo electrónico.")
      return false
    end
  end

  def asignar_username_con_opciones
    first_name = self.first_name
    second_name = self.second_name
    surname = self.surname
    second_surname = self.second_surname

    inicial_first_name = first_name[0..0] #obtiene la 1era letra del 1er nombre
    inicial_second_name = second_name[0..0] #obtiene la 1era letra del 2do nombre
    inicial_second_surname = second_surname[0..0] #obtiene la 1era letra del segundo apellido
    usuario_opcion_1 = (inicial_first_name+surname).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s #combina la 1era letra del 1er nombre con el 1er apellido
    usuario_opcion_2 = (inicial_first_name+inicial_second_name+surname).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s #combina la 1era letra del 1er nombre con 1era letra del 2do nombre con el 1er apellido
    usuario_opcion_3 = (inicial_first_name+inicial_second_name+surname+inicial_second_surname).mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s #combina la 1era letra del 1er nombre con 1era letra del 2do nombre con el 1er apellido y 1era letra del segundo apellido

    @user_empleyee = User.find_by username: usuario_opcion_1
    if @user_empleyee.nil?
      @usuario_nuevo = usuario_opcion_1
    else
      @user_empleyee = User.find_by username: usuario_opcion_2
      if @user_empleyee.nil?
        @usuario_nuevo = usuario_opcion_2
      else
        @user_empleyee = User.find_by username: usuario_opcion_3
        if @user_empleyee.nil?
          @usuario_nuevo = usuario_opcion_3
        else
          #== Esta sección verifica si el employee que se esta registrando tiene un user_id asignado,
           # para luego asignarle un valor a la variable @usuario_nuevo, esta me permitira verificar en
           # la vista 'show' de employee si esta nula o no, para asi mostrar(si esta nula)
           # un text_field y solicitar que ingrese manualmente el usuario que se le registrara a ese usuario
          unless self.user.nil?
            if self.user.username.nil?
              @usuario_nuevo = nil
            else
              @usuario_nuevo = self.user.username
            end
          else
            @usuario_nuevo = nil
          end
          #fin se sección
        end
      end
    end
    return @usuario_nuevo
  end

  #Metodo que permite crear el usuario automaticamente cada vez que se registre cada empleado
  def registrar_usuario
    employee_user = User.new
    employee_user.email = self.email
    employee_user.password = employee_user.generar_password
    employee_user.username = asignar_username_con_opciones
    if asignar_username_con_opciones.present?
      employee_user.username = asignar_username_con_opciones
    else
      employee_user.username =  self.usuario.downcase
    end
    employee_user.client_type = 'empleado'
    employee_user.save
    update(user_id: employee_user.id, user_created_id: employee_user.id)    
    #luego de registrar al usuario se almacena la contraseña en la tabla Historypassword
    #donde se almacenaran las 3 ultimas usadas
    password_employee = HistoryPassword.new
    password_employee.password = employee_user.password
    password_employee.user_id = employee_user.id
    password_employee.save
  end
  #Metodo donde se verifica si el usuario que se intententa crear esta usado o no por un empleado
  def validate_username?
    @user = User.find_by username: self.usuario
    unless self.usuario == ""
      unless @user.nil? 
        #Luego de que se verifica que el usuario si es usado, se pregunta si ese username pertenece al mismo
        #empleado que actualizara sus datos
        if self.usuario == self.user.username  
          #si es el mismo username retorna true  
          return true
        else
          #si es el mismo username retorna false        
          errors.add(:usuario, :invalid)
          return false
        end
      else
        #no existe ningún usuario con este username que se intenta registrar
        return true
      end
    else
      errors.add(:usuario, "Debe ingresar un usuario.")
      return false
    end  
  end

  def es_clinica?
    if $empleado == "externo"
    end
  end

  def es_novo?
    if $empleado == "interno"
    end
  end

  def verificar_usuario_empleados
    @user = User.find_by id: @employee.user_id
    if @user.username.nil?
      errors.add(:usuario, "Ya Usuario existe")
      return true
    end
  end

  def self.search(search)
    joins(:people).where(' lower("people"."first_name") ILIKE ? OR lower("people"."surname") ILIKE ?
      OR cast("people"."identification_document" as text) ILIKE ? ' ,
      "%#{search}%" , "%#{search}%" , "%#{search}%")
  end

  #coloca en mayuscula la primera letra de nombre y apellido
  def second_name=(n)
    write_attribute(:second_name, n.to_s.titleize)
  end

  def second_surname=(s)
    write_attribute(:second_surname, s.to_s.titleize)
  end

  def usuario_externo
    if $empleado == 'externo'
      @perfil = Security::Profile.find_by(name: "Analista clínica")
      self.security_profiles_id = @perfil.id
    end
  end    

  def update_email?
    if  self.user.email != self.email
      self.user.update(email: self.email)
      return true      
    end 
  end

  def activar_usuario
    self.user.update(is_active: true)
  end

  def registrar_motivo
    unless self.motive.nil?
      @user = User.find_by(id: self.user_id)
      registrar_motivo = MotiveEmployee.new
      registrar_motivo.user_created_id = @user.id
      registrar_motivo.motive = self.motive
      registrar_motivo.employee_id = self.id
      if $motivo == "eliminar"
        registrar_motivo.status = "Eliminado"
      else  
        registrar_motivo.status = self.status
      end  
      registrar_motivo.save  
      $motivo=nil    
    end
  end

  def inactivar_usuario
     self.user.update(is_active: false) 
  end 

  def limpiar_correo_employee
    self.update(email: self.email<<".eliminado") 
    usuario = User.find_by(id: self.user_id)
    correo = usuario.email<<'.eliminado'
    usuario.attributes = {:email => correo}
    usuario.skip_reconfirmation!
    usuario.save  
  end


  def unblocked_employee
    @user = User.new
    self.user.update(:password => @user.generar_password,:failed_attempts => 0, :unlock_token => nil, 
      :locked_at => nil, :updated_at => Date.today,:password_changed_at=>Date.today, 
      :temporary_password => true,:temporary_password_valid => true)
  end

  def reenviar_password
    @user = User.new
    self.user.update_attributes(:password => @user.generar_password,:reset_password_token => nil, :reset_password_sent_at=> nil,
     :password_changed_at=>Date.today, :temporary_password => true,:temporary_password_valid => true)
  end

  def temporary_password_valid
    self.user.update(temporary_password_valid: false)    
  end

  handle_asynchronously :temporary_password_valid, run_at: Proc.new { 1.days.from_now }

  # Fecha en que se ejecutara el job, es la fecha hasta del validez del perfil
  
  def fecha_validez
    run_at = self.date_valid
  end

  def vencer_perfil
    self.update(security_profiles_id: self.previous_profile_security, type_profile:"Permanente", date_valid: nil)
  end

  handle_asynchronously :vencer_perfil, run_at: Proc.new {|i| i.fecha_validez}

  def nombre_apellido
    "#{first_name} #{surname}"
  end
end
