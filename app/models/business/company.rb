class Business::Company < ApplicationRecord
  belongs_to :business_company_type, class_name: Business::CompanyType, foreign_key: :business_company_type_id, dependent: :destroy
  belongs_to :user
  has_many :payment_plans
  after_create :registrar_usuario
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
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  TYPE_COMPANY_OPTIONS = [ "V", "G", "J", "C" ]
  VALID_NUMBER_REGEX = /\A[0-9]*\z/
  validates :user, :presence =>{:message =>"No se pudo crear el usuario."}, on: [:update]
  validates :user, :uniqueness =>{:message =>"No se pudo crear el usuario."}
  validates :rif,:presence =>{:message =>"Debe ingresar un RIF."},
  :uniqueness => {:message => "Existe un registro con este RIF."},
  format: {:with => VALID_NUMBER_REGEX, message: "Solo se admiten números." }
  validates :address, :presence =>{:message =>"Debe ingresar una dirección."}
  validates :email, uniqueness: {message:"Existe un registro con este correo electrónico."},
  format: { :with => VALID_EMAIL_REGEX , message: "El correo electrónico es inválido." } ,
  :presence =>{:message =>"Debe ingresar un correo electrónico."}
  validates :business_company_type_id,:presence =>{:message =>"Debe ingresar un tipo de empresa."}, numericality: { message: " Se permite solo números enteros", only_integer: true }
  validates :name, :presence =>{:message =>"Debe ingresar una razón social."},
  :uniqueness => {:message => "Existe un registro con esta razón social."}
  validates :firt_name_responsable, :presence =>{:message =>"Debe ingresar un nombre del responsable de la empresa."}
  validates :last_name_responsable, :presence =>{:message =>"Debe ingresar un apellido del responsable de la empresa."}
  validates :phone, :presence =>{:message =>"Debe ingresar un número de teléfono."}
  validates :rif, :phone, :numericality => {  message: "Se permite solo números enteros",only_integer: true }
  
  validate :verificar_email_existente, on: [:create,:update]
  attr_accessor :password_company

  #Guarda el nombre con la primera letra de cada palabra en mayuscula
  def name=(s)
    write_attribute(:name, s.to_s.titleize)
  end

  def verificar_email_existente
    email_existe = User.find_by(email: self.email)
    if email_existe && self.user_id != email_existe.id
      errors.add(:email, "Existe un registro con este correo electrónico.")
      return false
    end
  end
  #Metodo que permite crear el usuario automaticamente
  def registrar_usuario
    business_user = User.new
    business_user.email = self.email
    business_user.password = business_user.generar_password
    business_user.client_type = 'empresa'
    business_user.save
    update(user_id: business_user.id, user_created_id: business_user.id)
    #luego de registrar al usuario se almacena la contraseña en la tabla Historypassword
    #donde se almacenaran las 3 ultimas usadas
    password_business = HistoryPassword.new
    password_business.password = business_user.password
    password_business.user_id = business_user.id
    password_business.save
  end
  def update_email?
    if  self.user.email != self.email
      self.user.update(email: self.email)
      return true
    end 
  end
  #Metodo que concatena en tipo de identificacion(type_identification) y el numero de identificacion(identification_document)
  def identificacion_company
    "#{type_identification}-#{rif}"
  end
end