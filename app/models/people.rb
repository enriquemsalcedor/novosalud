class People < ApplicationRecord
  has_one :beneficiary, class_name: Beneficiary, foreign_key: :people_id
  has_one :customer, class_name: Customer, foreign_key: :people_id
  has_one :provider_medico, class_name: Provider::Medico, foreign_key: :people_id

  attr_accessor :beneficiario, :employee, :cliente

  #arreglos que se cargan en los combos
  SEX_OPTIONS = ["Femenino","Masculino"]
  CIVIL_STATUS_OPTIONS = [ "Soltero", "Casado","Divorciado","Viudo" ]
  TYPE_IDENTIFICATION_OPTIONS = [ "V", "E","P" ]
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_NAME_REGEX = /\A[\p{L}\p{M}\'\ ]+\z/
  VALID_NUMBER_REGEX = /\A[0-9]*\z/

  #Validaciones
  validates :email, :presence =>{:message =>"Debe ingresar un correo electrónico."}, 
  uniqueness: {message:"Existe un registro con este correo electrónico."},
  format: { :with => VALID_EMAIL_REGEX , message: "El formato del correo electrónico es inválido." }, 
  :if=> :is_cliente?
  validates :phone, :presence =>{:message =>"Debe colocar un número teléfonico."}, numericality: { only_integer: true },
  :if => :verificar_cliente_beneficiario?
  validates :phone,  format: {:with => VALID_NUMBER_REGEX, message: "Solo se admiten números." }
  validates :identification_document, uniqueness: {message:"Existe un registro con esta cédula de identidad."},
  :presence => {:message =>"Debe ingresar un número de cedula."},
  numericality: { only_integer: true, message:"solo acepta números." },
  length: { in: 3..9 , message: "debe tener entre 3 y 9 caracteres."},
  format: {:with => VALID_NUMBER_REGEX, message: "Solo se admiten números." }
  validates :first_name, :presence =>{:message =>"Debe ingresar nombre(s)."}, length: { maximum: 50 },
  format: {:with => VALID_NAME_REGEX, message: "Solo se admiten letras o el carácter especial (')" }
  validates :surname, :presence =>{:message =>"Debe ingresar apellido(s)."}, length: { maximum: 50 },
  format: {:with => VALID_NAME_REGEX, message: "Solo se admiten letras o el carácter especial (')" }
  validates :type_identification, :presence =>{:message =>"Debe ingresar un tipo de identificación."}
  validates :sex, presence: true, inclusion: { in: SEX_OPTIONS }, :if=> :verificar_cliente_beneficiario?
  validates :date_birth, presence: true, :if => :is_cliente?
  validates_date :date_birth, :before => lambda { 18.years.ago },
                               :before_message => "Debe tener mas de 18 años",
                               :if => :is_cliente?

                           
  def is_cliente?
    self.cliente
  end

  def is_empleado?
    self.employee
  end

  def verificar_cliente_beneficiario?
    self.cliente || self.beneficiario
  end

  def verificar_cliente_empleado?
    self.cliente || self.employee
  end

  #coloca en mayuscula la primera letra de nombre y apellido
  def firt_name=(n)
    write_attribute(:first_name, n.to_s.titleize)
  end

  def last_name=(s)
    write_attribute(:surname, s.to_s.titleize)
  end

  def nombre_apellido
    "#{first_name} #{surname}"
  end

end
