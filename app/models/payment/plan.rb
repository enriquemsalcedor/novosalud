class Payment::Plan < ApplicationRecord
  has_many :payment_contracted_products , class_name: Payment::ContractedProduct
  has_many :payment_contracted_packages , class_name: Payment::ContractedPackage 
  belongs_to :sale_quotation , class_name: Sale::Quotation, foreign_key: :sale_quotation_id
  belongs_to :customer , class_name: Customer , foreign_key: :customer_id
  belongs_to :business_company, class_name: Business::Company, foreign_key: :company_id
  belongs_to :method_payment , class_name: MethodPayment, foreign_key: :method_payment_id
  belongs_to :bank, class_name: Bank, foreign_key: :bank_id

  after_create :crear_productos_contratados
  after_create :crear_paquetes_contratados
  after_save :pagar_cotizacion
  after_create :enviar_certificado_cliente

  validates :method_payment_id , presence: {:message =>"Debe seleccionar una modalidad de pago."}
   auto_increment :number_plan, scope: [nil, nil], initial: 'P-1', force: true, lock: false, before: :create

  # Metodo que crea los productos contratados, que se encuentran en la cotizacion.
  def crear_productos_contratados
    @lis_products = Sale::ProductQuotation.where(sale_quotation_id: self.sale_quotation_id)
    @lis_products.each do |product|
      product.quantity.times do
        Payment::ContractedProduct.create(
          plan_id: self.id,
          product_product_id: product.product_product_id,
          price_contracted: product.product_product.price,
          valid_until: Date.today + product.product_product.valid_days,
          user_created_id: self.user_created_id)
      end
    end
  end

  # Metodo que crea los paquetes contratados, que se encuentran en la cotizacion.
  def crear_paquetes_contratados
    @lis_packages = Sale::PackageQuotation.where(sale_quotation_id: self.sale_quotation_id)
    @lis_packages.each do |package|
      package.quantity.times do

        Payment::ContractedPackage.create(
          plan_id: self.id,
          colection_package_id: package.colection_package_id,
          price_contracted: package.colection_package.total_amount)

          contracted_package = Payment::ContractedPackage.last

          # Se crean los productos que se encuentran en los paquetes de una cotizacion
          # y se registran en productos contratados.
          Colection::PackageProduct.where(colection_package_id: package.colection_package_id).each do |product|
            product.quantity.times do
              Payment::ContractedProduct.create(
                plan_id: self.id,
                product_product_id: product.product_product_id,
                user_created_id: self.user_created_id,
                valid_until: Date.today + product.product_products.valid_days,
                payment_contracted_package_id: contracted_package.id)
            end
          end
      end
    end
  end

  aasm column: "status" do
    state :Pagado, initial: true
    state :Agotado
    state :Vencido

    event :agotar do
      transitions from: :Pagado, to: :Agotado
    end

    event :vencer do
      transitions from: :Pagado, to: :Vencido
    end
  end

  # Metodo que se ejecuta despues de registrar un Plan y que cambia de estatus la
  # cotizacion que se encuentra Vigente a Pagada
  def pagar_cotizacion
    @cotizacion = Sale::Quotation.find(self.sale_quotation_id)
    if @cotizacion.may_pagar?
      @cotizacion.pagar!
    end
  end

  def self.search(search)
    joins(customer: :people).where(' "payment_plans"."number_plan" ILIKE ? OR "payment_plans"."status" ILIKE ?
      OR cast( "payment_plans"."created_at" as text) ILIKE ? OR "people"."first_name" ILIKE ? OR
      "people"."surname" ILIKE ? OR cast("people"."identification_document" as text) ILIKE ?' ,
      "%#{search}%" , "%#{search}%" , "%#{search}%" , "%#{search}%" , "%#{search}%" , "%#{search}%")
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |plan|
        csv << plan.attributes.values_at(*column_names)
      end
    end

  end
  def self.generar(fechaDesde , fechaHasta)
    where('("payment_plans"."created_at") >= ? AND ("payment_plans"."created_at" ) <= ?', "#{fechaDesde}" , "#{fechaHasta}")
  end
  def self.busqueda(busqueda)
    producto_contratado = self.new
    arreglo_union = []
    array_auxiliar = []
    producto_contratado =joins( payment_contracted_products:  [{product_product: :provider_provider}]).where('"payment_plans"."number_plan" ILIKE ? 
      OR "payment_plans"."status" ILIKE ? 
      OR "product_products"."name" ILIKE ? 
      OR "provider_providers"."name" ILIKE ? ' ,
      "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%" , "%#{busqueda}%")

      producto_contratado.each do |quotationa|
        array_auxiliar.push(quotationa)     
      end
      arreglo_union = array_auxiliar.collect {|x| x}.uniq
      return arreglo_union
  end

  def nombre_titular
   "#{customer.people.first_name} #{customer.people.surname}"
  end

  def cedula_titular
   "#{customer.people.type_identification}-#{customer.people.identification_document}"
  end

  def enviar_certificado_cliente
    @paymente_contracted_product = Payment::ContractedProduct.where(plan_id: self.id)
      CertificateProductMailer.enviar_certificado(@paymente_contracted_product).deliver_now
  end

end
