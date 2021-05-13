class Colection::Package < ApplicationRecord
  has_many :colection_package_products, class_name: Colection::PackageProduct,foreign_key: :colection_package_id
  has_many :product_products , :through => :colection_package_products , class_name: Product::Product, foreign_key: :colection_package_id
  before_create :generar_codigo

  # estilo para guardar la imagen con un tamaño fijo de 200x200
  has_attached_file :image, styles: {medium:"200x200"}
  # validacion para solo aceptar archivo de tipo imagen
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  after_update :actualizar_vencimiento

  aasm column: "status"  do
    state  :Activo
    state  :Inactivo, initial: true

    event :habilitar do
      transitions from: :Inactivo, to: :Activo,
      after: [
        :vencer_paquete
      ]
    end

    event :inhabilitar do
      transitions from: :Activo, to: :Inactivo,
      after: [
        :eliminar_job
      ]
    end
  end

  CATEGORIES = [ "Individual", "PYMES" , "Ambas" ]

  #Guarda el nombre con la primera letra de cada palabra en mayuscula
  def name=(s)
    write_attribute(:description, s.to_s.titleize)
  end

  validates :valid_since , :presence =>{:message =>"Debe seleccionar una fecha de publicación."}
  validates_datetime :valid_until, :after => :valid_since, :after_message => "La fecha de publicación debe ser mayor a la fecha de expiración"
  validates :description ,:uniqueness => {:message => "Existe un registro con esta descripción"}
  validates :description, :presence =>{:message =>"Debe ingresar una descripción"}
  validates_numericality_of :total_amount, :presence =>{:message =>"Debe ingresar un monto total"},
  :greater_than_or_equal_to => 1 
  validates :category, :presence =>{:message =>"Debe seleccionar una categoria"}

  # metodo de busqueda por criterio
  # parametro (search)
  def self.search(search)
    where("description ILIKE ? OR cast(valid_since as text) ILIKE ?
      OR cast(valid_until as text) ILIKE ? OR cast(total_amount as text) ILIKE ?
      OR cast(created_at as text) ILIKE ? OR category ILIKE ? " ,
      "%#{search}%" , "%#{search}%" , "%#{search}%" , "%#{search}%" , "%#{search}%" , "%#{search}%")
  end

  def letra_aleatoria
    caracter = %w{ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z }
    posicion = rand(caracter.length)
    num_aleat = rand(caracter.length)

    return caracter[posicion] + caracter[num_aleat]
  end

  def generar_codigo
    codigo_aleatorio = ''
    cont = Colection::Package.select(:id).count
    secuence = cont + 1

    auxpackage = Colection::Package.new
    2.times do
      codigo_aleatorio << auxpackage.letra_aleatoria
    end
    self.code = "PAQ" + "-" + codigo_aleatorio + secuence.to_s
  end

  scope :activo, ->{ where(status: "Activo")}
  scope :pymes, ->{ where('category <> ?' , "Individual")}
  scope :individual, ->{ where('category <> ?' , "PYMES")}
  scope :no_cero, ->{ where('total_amount > 0')}

  # Fecha en que se ejecutara el job, es la fecha hasta del validez del paquete o promocion
  def fecha_validez
    run_at = self.valid_until
  end

  def vencer_paquete
    return self.Activo? ? self.inhabilitar! : false
  end

  handle_asynchronously :vencer_paquete, run_at: Proc.new {|i| i.fecha_validez}

  def actualizar_vencimiento
    job = Delayed::Job.find_by(id: self.job_id)
    job.update(run_at: self.valid_until) if job.presence
  end

  def eliminar_job
    job = Delayed::Job.find_by(id: self.job_id)
    unless job.nil?
      job.destroy #elimina el Job donde id = job_id del paquete
    end
  end

attr_accessor :verificar_paquete_nuevo
attr_accessor :cambio_categoria

end
