class Product::Product < ApplicationRecord
	belongs_to :speciality
  belongs_to :product_product_type , class_name: Product::ProductType, foreign_key: :product_product_type_id
  belongs_to :provider_provider , class_name: Provider::Provider, foreign_key: :provider_provider_id
  before_create :generar_codigo

  # estilo para guardar la imagen con un tamaño fijo de 200x200
  has_attached_file :image, styles: {medium:"200x200",large:"450x450"}
  # validacion para solo aceptar archivo de tipo imagen
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  validates :name,  :presence =>{:message =>"Debe ingresar un nombre."}
  validates :speciality_id , :presence =>{:message =>"Debe seleccionar una especialidad."}
  validates :provider_provider_id , :presence =>{:message =>"Debe seleccionar un proveedor."}
  validates :category , :presence =>{:message =>"Debe seleccionar una categoría."}
  validates :product_product_type_id , :presence =>{:message =>"Debe seleccionar un tipo de producto."}
  validates_datetime :expiration_date, :after => :publication_date, :after_message => "La fecha de expiración debe ser mayor a la fecha de publicación"
  validates :price , :presence =>{:message =>"Debe ingresar un precio unitario."}
  validates :valid_days , :presence =>{:message =>"Debe ingresar los días de validez para la activación del producto."},
            :numericality => {greater_than: 0, :message => "La cantidad debe ser mayor a 0."}  
  validates :publication_date , :presence =>{:message =>"Debe seleccionar una fecha de publicación."}
  
  after_update :actualizar_vencimiento

  aasm column: "status"  do
    state  :Activo
    state  :Inactivo, initial: true

    event :habilitar do
      transitions from: :Inactivo, to: :Activo,
          after: [
            :vencer_producto
          ]
    end

    event :inhabilitar do
      transitions from: :Activo, to: :Inactivo,
          after: [
            :eliminar_job
          ]
    end 
  end

  CATEGORIES = [ "Individual", "PYMES", "Ambas" ]

  scope :activo, ->{ where(status: "Activo")}
  scope :pymes, ->{ where('category <> ?' , "Individual")}
  scope :individual, ->{ where('category <> ?' , "PYMES")}
  scope :no_cero, ->{ where('price > 0')}

  def armar_nombre
    "#{self.name} - #{provider_provider.name}"
  end

  def nombre
    "#{self.name}"
  end

  def proveedor
    "#{provider_provider.name}"
  end

  #este método genera combinación de 2 letras
  def letra_aleatoria
    caracter = %w{ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z }
    posicion = rand(caracter.length)
    num_aleat = rand(caracter.length)

    return caracter[posicion] + caracter[num_aleat]
  end

  def generar_codigo
    codigo_aleatorio = ''
    type = self.product_product_type.name
  # abrv es la abreviatura del tipo de producto y se selecciona las 3 primeras posiciones del
  # string que recibe la variable type
  abrv = type[0..2].upcase
  # cont es contador de productos,  secuence es el valor de cont + 1
  cont = Product::Product.select(:product_product_type_id).count
  secuence = cont + 1

  auxproduct = Product::Product.new
  2.times do
    codigo_aleatorio << auxproduct.letra_aleatoria
  end
  self.code = abrv + "-" + codigo_aleatorio + secuence.to_s
  end

  # Fecha en que se ejecutara el job, es la fecha hasta del validez del producto
  def fecha_expiration
    run_at = self.expiration_date
  end

  def vencer_producto
    return self.Activo? ? self.inhabilitar! : false
  end

  handle_asynchronously :vencer_producto, run_at: Proc.new {|i| i.fecha_expiration}

# Fecha en que se ejecutara el job, es la fecha hasta del publicacio del producto
  def fecha_publicacion
    run_at = self.publication_date
  end

  def activar_producto
    return self.Inactivo? ? self.habilitar! : false
  end
  def self.search_product_by_speciality(id_speciality)
    where("speciality_id = ?", "#{id_speciality}")
  end   
  
  

  handle_asynchronously :activar_producto, run_at: Proc.new {|i| i.fecha_publicacion}

  def actualizar_vencimiento
    job = Delayed::Job.find_by(id: self.job_id)
    job.update(run_at: self.expiration_date) if job.presence
  end

  def eliminar_job
    job = Delayed::Job.find_by(id: self.job_id)
    unless job.nil?
      job.destroy # elimina el Job donde id = job_id del producto
    end
  end
    # metodo de busqueda por criterio
  # parametro (search)
  def self.search(search)
    busqueda = search.downcase
    joins(:speciality).joins(:product_product_type).joins(:provider_provider).where(' "product_products"."category" ILIKE ? OR "product_products"."name" ILIKE ?
      OR "product_products"."code" ILIKE ? OR cast("product_products"."created_at" as text) ILIKE ?
      OR cast("product_products"."publication_date" as text) ILIKE ? OR cast("product_products"."expiration_date" as text) ILIKE ?
      OR lower("product_product_types"."name") LIKE ? OR lower("specialities"."name") LIKE ? 
      OR lower("provider_providers"."name") LIKE ?' ,
      "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%" ,
      "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%", "%#{busqueda}%" )
  end
end

