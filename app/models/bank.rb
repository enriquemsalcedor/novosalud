class Bank < ApplicationRecord
  has_many :plans , class_name: Payment::Plan
  has_many :payment_transferences , class_name: Payment::Transference
  has_many :accounts, class_name: Account

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
 # estilo para guardar la imagen con un tamaño fijo 
  has_attached_file :image, styles: {logo:"150x150"}
  # validacion para solo aceptar archivo de tipo imagen
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  validates :name ,presence: true, uniqueness: true,  length: { minimum: 3, maximum: 50 }
  validates :direction_web,  :presence =>{:message =>"Debe ingresar la página web del banco."},
  :url =>{:message =>"La dirección de la página web no es válida. Ejemplo: https://www.pagina.com"}

  #Guarda el nombre con la primera letra de cada palabra en mayuscula
  def name=(s)
    write_attribute(:name, s.to_s.titleize)
  end

  # metodo de busqueda por criterio
  # parametro (search)
  def self.search(search)
    where("name ILIKE ?" , "%#{search}%")
  end

  scope :activo, ->{ where(status: "Activo")}


end

