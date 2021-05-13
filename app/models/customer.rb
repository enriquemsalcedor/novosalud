class Customer < ApplicationRecord
  belongs_to :people, class_name: People, foreign_key: :people_id, dependent: :destroy, :autosave => true
  belongs_to :user, class_name: User, foreign_key: :user_id
  has_many :payment_plans

  accepts_nested_attributes_for :people, :allow_destroy => true, :reject_if => :all_blank
  validates_associated  :people 

  validates :user, :presence =>{:message =>"No se pudo crear el usuario."}, on: [:update]
  validates :user, :uniqueness =>{:message =>"No se pudo crear el usuario."}
  validate :verificar_email_existente, on: [:create,:update]

  before_create :generar_codigo
  after_create :registrar_usuario
  attr_accessor :password_customer

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

  #este método genera combinación de 2 letras que en el controlador se repetira 5 veces y el mismo será el
  #codigo que se le asigna al cliente
  def letra_aleatoria
    caracter = %w{ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 1 2 3 4 5 6 7 8 9 0 }
    posicion = rand(caracter.length)
    num_aleat = rand(caracter.length)
    return caracter[posicion] + caracter[num_aleat]
  end

  def generar_codigo
    codigo_aleatorio = ''
    auxcostomer = Customer.new
    5.times do
      codigo_aleatorio << auxcostomer.letra_aleatoria
    end
    self.customer_code = codigo_aleatorio
  end

  #Metodo que concatena en nombre(first_name) y apellido(surname) del cliente que realiza la cotizacion
  def nombre_usuario
    "#{people.first_name} #{people.surname}".titleize
  end
  
  #Metodo que concatena en tipo de identificacion(type_identification) y el numero de identificacion(identification_document)
  def identificacion_usuario
    "#{people.type_identification}-#{people.identification_document}"
  end

  def verificar_email_existente
    email_existe = User.find_by(email: self.people.email)
    if email_existe && self.user_id != email_existe.id
      errors.add(:email, "Existe un registro con este correo electrónico.")
      return false
    end
  end

  #Metodo que permite crear el usuario automaticamente
  def registrar_usuario
    customer_user = User.new
    customer_user.email = self.people.email
    customer_user.password = customer_user.generar_password
    customer_user.client_type = 'persona'
    customer_user.save
    update(user_id: customer_user.id, user_created_id: customer_user.id)
    #luego de registrar al usuario se almacena la contraseña en la tabla Historypassword
    #donde se almacenaran las 3 ultimas usadas
    password_customer = HistoryPassword.new
    password_customer.password = customer_user.password
    password_customer.user_id = customer_user.id
    password_customer.save
  end

  def update_email?
    if  self.user.email != self.people.email
      self.user.update(email: self.people.email)
      return true
    end 
  end

  def existe_persona
    @people= People.find_by(identification_document:  self.people.identification_document)
    unless @people.nil?
        if @people.email.nil?
          @people.email = self.people.email
        end

        if @people.date_birth.nil?
          @people.date_birth = self.people.date_birth
        end

        if @people.sex.nil?
          @people.sex = self.people.sex        
        end

        if @people.phone.nil?
          @people.phone = self.people.phone        
        end
        self.people = @people
    end 
  end
end
