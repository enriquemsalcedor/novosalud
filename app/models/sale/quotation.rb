class Sale::Quotation < ApplicationRecord
  has_many :sale_package_quotation, class_name: Sale::PackageQuotation, foreign_key: :sale_quotation_id
  has_many :colection_package, through: :sale_package_quotation, class_name: Colection::Package, foreign_key: :colection_package_id

  has_one :payment_plan , class_name: Payment::Plan
  belongs_to :user , class_name: User, foreign_key: :user_id

  has_many :sale_product_quotations, class_name: Sale::ProductQuotation, foreign_key: :sale_quotation_id

  has_many :product_product , :through => :sale_product_quotations, class_name: Product::Product, foreign_key: :product_product_id

  auto_increment :quoting_number, scope: [nil, nil], initial: 'C-1', force: true, lock: false, before: :create

  validates_date :valid_until, :after => :today, :after_message => 'Debe ser mayor a la fecha de hoy.',
  if: "self.status == 'Vencida'", on: [:reactivar]


  scope :cotizadas, ->{ joins("LEFT OUTER JOIN payment_transferences ON sale_quotations.id = payment_transferences.sale_quotation_id").where("sale_quotations.status = ? OR sale_quotations.status = ?" ,  "Vencida" , "Vigente")}
  scope :vigentes, ->{ where(status: "Vigente")}

  attr_reader :dias_vigencia

  aasm column: "status"  do
    state  :En_cotizacion, initial: true
    state  :Vigente
    state  :Procesada
    state  :Vencida

    event :cotizar do
      transitions from: :En_cotizacion, to: :Vigente,
                  after: [
                    :fecha_vigencia
                  ]
    end

    event :pagar do
      transitions from: :Vigente, to: :Procesada
    end

    event :vencer do
      transitions from: :Vigente, to: :Vencida
    end

    event :reactivar do
      transitions from: :Vencida, to: :Vigente,
                  after: [
                    :reactivar_cotizacion
                  ]
    end
  end

  #Este arreglo junto con el metodo QUANTITY_OPTIONS, se desarrollo para el listado desplegable de cantidad en el carrito de compras especificamente en la vista home#cart, esta lista posee un metodo change que permite la persistencia de la seleccion hecha.
  array = Array.new
  for i in 1..100
    array << i
  end
  QUANTITY_OPTIONS = array

  #Metodo que concatena en nombre(first_name) y apellido(surname) del cliente que realiza la cotizacion
  def nombre_usuario
    "#{user.customer.people.first_name} #{user.customer.people.surname}".titleize
  end

  #Metodo que concatena en tipo de identificacion(type_identification) y el numero de identificacion(identification_document)
  # de la cedula del cliente que realiza la cotizacion
  def identificacion_usuario
    "#{user.customer.people.type_identification}-#{user.customer.people.identification_document}"
  end

  #Metodo que itera los productos y paquetes de una cotizacion y suma los precios
  def sumar_montos
    acum = 0
    @lis_products = Sale::ProductQuotation.where(sale_quotation_id: self.id)
      @lis_products.each do |product|
        product.quantity.times do
          acum =  acum + product.product_product.price
        end
      end

    @lis_packages = Sale::PackageQuotation.where(sale_quotation_id: self.id)
    @lis_packages.each do |package|
      package.quantity.times do
        acum =  acum + package.colection_package.total_amount
      end
    end
    return acum
  end

  # metodo de busqueda por criterio
  # parametro (search)
 def self.search(search)
    joins( user:  [{customer: :people }]).where(' "sale_quotations"."quoting_number" ILIKE ? 
      OR "sale_quotations"."status" ILIKE ? 
      OR cast("sale_quotations"."valid_since" as text) ILIKE ?
      OR cast("sale_quotations"."valid_until" as text) ILIKE ?
      OR "people"."first_name" ILIKE ? 
      OR "people"."surname" ILIKE ? 
      OR cast("people"."identification_document" as text) ILIKE ?' ,
      "%#{search}%" , "%#{search}%" , "%#{search}%" , "%#{search}%" , "%#{search}%" , "%#{search}%", "%#{search}%")

  end



  def self.busqueda(busqueda)
    consulta_producto = self.new
    consulta_paquete = self.new
    arreglo_union = []
    array_auxiliar = []
   consulta_producto =joins( sale_product_quotations:  [{product_product: :provider_provider}]).where('"sale_quotations"."quoting_number" ILIKE ? 
      OR "sale_quotations"."status" ILIKE ? 
      OR cast("sale_quotations"."valid_since" as text) ILIKE ?
      OR cast("sale_quotations"."valid_until" as text) ILIKE ?
      OR "product_products"."name" ILIKE ? 
      OR "provider_providers"."name" ILIKE ? ' ,
      "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%")
    consulta_paquete =joins( sale_package_quotation:  [{colection_package: {colection_package_products: :product_products}}] ).where('"sale_quotations"."quoting_number" ILIKE ? 
      OR "sale_quotations"."status" ILIKE ? 
      OR cast("sale_quotations"."valid_since" as text) ILIKE ?
      OR cast("sale_quotations"."valid_until" as text) ILIKE ?
      OR "colection_packages"."description" ILIKE ? 
      OR "product_products"."name" ILIKE ? ' ,
      "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%")

      consulta_paquete.each do |quotationb|
        array_auxiliar.push(quotationb)    
      end
      
      consulta_producto.each do |quotationa|
        array_auxiliar.push(quotationa)     
      end
      arreglo_union = array_auxiliar.collect {|x| x}.uniq
      return arreglo_union

  end

  def total_cotizacion
    total = 0
    unless self.sale_product_quotations.empty?
      self.sale_product_quotations.each do |pq|
        total += pq.monto_pagar.round(2)
      end
    end
    unless self.sale_package_quotation.empty?
      self.sale_package_quotation.each do |pq|
        total += pq.monto_pagar.round(2)
      end
    end
    "%.2f" % (total) # se le da formato al total con 2 decimales 
  end
  
  def cant_total
    cant_total = 0
    unless self.sale_product_quotations.empty?
      self.sale_product_quotations.each do |pq|
        cant_total += pq.quantity
      end
    end
    unless self.sale_package_quotation.empty?
      self.sale_package_quotation.each do |pq|
        cant_total += pq.quantity
      end
    end
   return cant_total
  end


  def dias_vigencia
    run_at = InitialValue.find(1).days_validity.to_i
    run_at.days.from_now
  end

  def vencer_cotizacion
    return self.Vigente? ? self.vencer! : false
  end

  def vigencia
    run_at = self.valid_until
  end

  def reactivar_cotizacion
    return self.Vencida? ? self.reactivar! : false
  end

  handle_asynchronously :vencer_cotizacion, run_at: Proc.new {|i| i.dias_vigencia}

  handle_asynchronously :reactivar_cotizacion, run_at: Proc.new {|i| i.vigencia}

  def verificar_cantidad_maxima
    @package_quotations = self.sale_package_quotation.order(id: :asc)
    @product_quotations = self.sale_product_quotations.order(id: :asc)

    @cantidad_maxima = InitialValue.find(1).max_quantity_product

    hash_producto = {}
    @package_quotations.each do |package_quotation|
      if package_quotation.colection_package.colection_package_products.length > 0
        package_quotation.colection_package.colection_package_products.each do |pp|
          if hash_producto[pp.product_products].nil?
            hash_producto[pp.product_products] = pp.quantity * package_quotation.quantity
          else
            hash_producto[pp.product_products] = hash_producto[pp.product_products] + (pp.quantity * package_quotation.quantity)
          end
        end
      end
    end

    if @product_quotations.length > 0
      @product_quotations.each do |producto|
        if hash_producto[producto.product_product].nil?
          hash_producto[producto.product_product] = producto.quantity
        else
          hash_producto[producto.product_product] = hash_producto[producto.product_product] + producto.quantity
        end
    
      end
    end

    hash_producto.select!{|k,v| v > @cantidad_maxima}
    if hash_producto.length > 0
      Thread.new do
        MaxQuantityNotifyMailer.notify(self,hash_producto).deliver_now
        ActiveRecord::Base.connection.close
      end
    end
  end

  private
    def fecha_vigencia
      update(valid_since: Time.current ,valid_until: dias_vigencia )
    end
end
