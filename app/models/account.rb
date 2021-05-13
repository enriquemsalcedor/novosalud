class Account < ApplicationRecord
  belongs_to :bank
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :bank_id , :presence =>{:message =>"Debe seleccionar un banco."}
  validates :account_number,  :presence =>{:message =>"Debe ingresar un número de cuenta."},
            numericality: { only_integer: true, message:"Debe ingresar solo números." },
            length: { minimum: 20 , message:"Debe tener 20 caracteres." } 
  validates :account_type,  :presence =>{:message =>"Debe seleccionar un tipo de cuenta."}
  validates :email, :presence =>{:message =>"Debe ingresar un correo electrónico."},
  format: { :with => VALID_EMAIL_REGEX , message: "El formato del correo electrónico es inválido." }
 
  ACCOUNT_TYPES = [ "Corriente", "Ahorro" ]

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

  def formato_cuenta
    cuenta = ""
    block1 = self.account_number[0..3]
    block2 = self.account_number[4..7]
    block3 = self.account_number[8..9]
    block4 = self.account_number[10..19]

    formato = block1 +"-"+ block2 +"-"+ block3 +"-"+ block4
    
  end

  def nombre_banco
    "#{self.bank.name}"    
  end
  
end
