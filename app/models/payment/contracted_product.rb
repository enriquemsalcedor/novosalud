class Payment::ContractedProduct < ApplicationRecord
  belongs_to :payment_plan , class_name: Payment::Plan,foreign_key: :plan_id 
  belongs_to :product_product , class_name: Product::Product ,foreign_key: :product_product_id 
  before_create :generar_codigo
  has_one :service_service, class_name: Service::Service, foreign_key: :payment_contracted_product_id
  belongs_to :payment_contracted_package , class_name: Payment::ContractedPackage ,foreign_key: :payment_contracted_package_id 

  after_commit :agotar_plan, if: "self.status=='Usado' && self.payment_plan.status=='Pagado'"
  after_commit :vencer_plan, if: "self.payment_plan.status=='Pagado'"
  after_create :expirar_producto
  after_create :asignar_job

  #Metodo que permite buscar el producto contratado
  def self.search(searchProduct)
    searchProduct.downcase!
    where(" lower(code) = ?", "#{searchProduct}")
  end

  aasm column: "status"  do
    state  :Pagado, initial: true
    state  :Activado
    state  :Usado
    state  :Anulado
    state  :Expirado

    event  :activar do
      transitions from: :Pagado , to: :Activado,
      after: [
        :eliminar_job
      ]
    end

    event :revertir do
      transitions from: :Activado , to: :Pagado,
      after: [
        :expirar_producto,
        :asignar_job
      ]
    end

    event :anular do
      transitions from: :Activado , to: :Anulado
    end

    event :agotar do
      transitions from: :Activado , to: :Usado
    end

    event :expirar do
      transitions from: :Pagado , to: :Expirado
    end

  end

  #este método genera combinación de 2 letras que en el controlador se repetira 5 veces y el mismo será el
  #codigo que se le asigna al producto contratado en el plan
  def codigo_aleatorio
    caracter = %w{ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z 1 2 3 4 5 6 7 8 9 }
    posicion = rand(caracter.length)
    num_aleat = rand(caracter.length)

    return caracter[posicion] + caracter[num_aleat]
  end

  def generar_codigo
    aleatorio = ''
    aux = Payment::ContractedProduct.new
    6.times do
      aleatorio << aux.codigo_aleatorio
    end

    block1 = aleatorio[0..3]
    block2 = aleatorio[4..7]
    block3 = aleatorio[8..11]
    certificado = block1 +"-"+ block2 +"-"+ block3
    self.code = certificado
  end

  def cliente
    if payment_plan.customer.nil?
      payment_plan.business_company
    else
      payment_plan.customer.people
    end
  end

  def agotar_plan
    @products = Payment::ContractedProduct.where(:plan_id => self.plan_id)
    @total_products = @products.count
    @usados = @products.select{|p| p.status == 'Usado'}.count
    # si el total de productos de un plan es igual al total de productos usados, el plan esta agotado
    # y se ejecuta el metodo agotar del plan
    if @total_products == @usados
      self.payment_plan.agotar!
    end
  end

  def vencer_plan
    @products = Payment::ContractedProduct.where(:plan_id => self.plan_id)
    @total_products = @products.count
    @usados_anulados = @products.select{|p| p.status == 'Usado' || p.status == 'Anulado' || p.status == 'Expirado'}.count
    # si el total de productos de un plan es igual al total de productos usados o anulados, el plan esta agotado
    # y se ejecuta el metodo agotar del plan
    if @total_products == @usados_anulados
      self.payment_plan.vencer!
    end
  end

  def expirar_producto
    return self.Pagado? ? self.expirar! : false
  end

  def dias_validez
    run_at = self.valid_until
  end

  handle_asynchronously :expirar_producto, run_at: Proc.new {|i| i.dias_validez}

  def eliminar_job
    job = Delayed::Job.find_by(id: self.job_id)
    unless job.nil?
      job.destroy #elimina el Job despues q se active el producto
      self.update(:job_id => nil)# se pasa a nulo el job_id ya que el Job fue eliminado
    end
  end

  def asignar_job
    job = Delayed::Job.last
    self.update(:job_id => job.id) #asigna el id del Job al atributo job_id
  end

end
