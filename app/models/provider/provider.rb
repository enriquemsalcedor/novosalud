class Provider::Provider < ApplicationRecord
  belongs_to :provider_provider_type, class_name: Provider::ProviderType, foreign_key: :provider_provider_type_id, dependent: :destroy
  belongs_to :territory_country, class_name: Territory::Country , foreign_key: :territory_country_id
  belongs_to :territory_state, class_name: Territory::State , foreign_key: :territory_state_id, optional: true
  belongs_to :territory_city, class_name: Territory::City , foreign_key: :territory_city_id, optional: true

  has_many :provider_medico_providers, class_name: Provider::MedicoProvider, foreign_key: :provider_provider_id
  has_many :provider_medicos, through: :provider_medico_providers, class_name: Provider::Provider
  has_many :employee, class_name: Employee, foreign_key: :provider_provider_id
  before_create :generar_codigo
  
  # estilo para guardar la imagen con un tamaño fijo de 200x200
  has_attached_file :image, styles: {medium:"200x200",large:"450x450"}
  # validacion para solo aceptar archivo de tipo imagen
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

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

  scope :activo, ->{ where(status: "Activo")}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_NAME_REGEX = /\A[\p{L}\p{M}\'\ ]+\z/ 
  TYPE_IDENTIFICATION_OPTIONS = [ "V", "E","P" ]
  TYPE_PERSONA_OPTIONS = [ "V", "E","P", "G", "J", "C" ]

  validates :phone, :phone_responsable,:presence =>{:message =>"Debe ingresar un número de teléfono."}
  validates :provider_provider_type_id,numericality: { only_integer: true }
  validates :name,:presence =>{:message =>"Debe ingresar una razón social."},
  :uniqueness => {:message => "Existe un registro con este razón social."}
  validates :rif,:presence =>{:message =>"Debe ingresar un RIF."},
  :uniqueness => {:message => "Existe un registro con este RIF."},
   numericality: { only_integer: true,:message => "Sólo se permiten caracteres numéricos." }
  validates :address, :presence =>{:message =>"Debe ingresar un dirección."}
  validates :email, uniqueness: {message:"Existe un registro con este correo electrónico."},
  format: { :with => VALID_EMAIL_REGEX , message: "Correo electrónico invalido." } ,
   :presence =>{:message =>"Debe ingresar un correo electrónico."}
  validates :email_responsable, :presence =>{:message =>"Debe ingresar un correo electrónico."}
  validates :firt_name_responsable, :presence =>{:message =>"Debe ingresar un nombre."}, 
  format: {:with => VALID_NAME_REGEX, message: "Solo se admite letras o el carácter especial (')." }
  validates :last_name_responsable, :presence =>{:message =>"Debe ingresar un apellido."},
   format: {:with => VALID_NAME_REGEX, message: "Solo se admite letras o el carácter especial (')." }
  validates :identification_document,:presence =>{:message =>"Debe ingresar un número de cédula."}
  validates :position,:presence =>{:message =>"Debe ingresar un cargo."}
  

  #Guarda el nombre con la primera letra de cada palabra en mayuscula
  def name=(s)
    write_attribute(:name, s.to_s.titleize)
  end

  def firt_name_responsable=(n)
    write_attribute(:firt_name_responsable, n.to_s.titleize)
  end

  def last_name_responsable=(s)
    write_attribute(:last_name_responsable, s.to_s.titleize)
  end

  # metodo de busqueda por criterio
  # parametro (search)
  def self.search(search)
      joins(:provider_provider_type).where(' "provider_providers"."name" ILIKE ? OR "provider_providers"."rif" ILIKE ? OR "provider_providers"."phone" ILIKE ? 
      OR "provider_providers"."email" ILIKE ? ' , 
      "%#{search}%" , "%#{search}%" , "%#{search}%" ,  "%#{search}%" )    
  end

  def letra_aleatoria
    caracter = %w{ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 1 2 3 4 5 6 7 8 9 0 }
    posicion = rand(caracter.length)
    num_aleat = rand(caracter.length)
    return caracter[posicion] + caracter[num_aleat]
  end
  
  def generar_codigo
    codigo_aleatorio = ''
    auxcostomer = Provider::Provider.new
    5.times do
      codigo_aleatorio << auxcostomer.letra_aleatoria
    end
    self.clinic_code = codigo_aleatorio
  end


end
