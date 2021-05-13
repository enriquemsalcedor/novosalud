class Service::Service < ApplicationRecord
  belongs_to :beneficiary, class_name: Beneficiary, foreign_key: :beneficiary_id
  belongs_to :provider_medico_provider, class_name: Provider::MedicoProvider,  foreign_key: :provider_medico_provider_id, optional: true
  belongs_to :motive , class_name: Motive, foreign_key: :motive_id, optional: true
  belongs_to :payment_contracted_product, class_name: Payment::ContractedProduct, foreign_key: :payment_contracted_product_id

  after_create :guardar_movimiento_servicio
  after_create :enviar_correo_cliente
  after_create :anular_servicio
  after_create :asignar_job

  auto_increment :code, scope: [nil, nil], initial: 'S-1', force: true, lock: false, before: :create

  validates_date :appointment_date, :on_or_after => :today, :on_or_after_message => 'Debe ser mayor o igual a la fecha de hoy.',
  :if => :validar_estatus?

  aasm column: "status"  do
    state  :Activado, initial: true
    state  :Usado
    state  :Reagendado
    state  :Cancelado
    state  :Anulado
    state  :Agendado

    event  :atender do
      transitions from: [:Activado, :Reagendado,:Agendado],  to: :Usado,
          after: [
            :eliminar_job
          ]
    end

    event :reagendar do
      transitions from: :Cancelado, to: :Reagendado,
          after: [
            :anular_servicio,
            :asignar_job
          ]
    end

    event :cancelar do
      transitions from: [:Activado, :Reagendado,:Agendado], to: :Cancelado
    end

    event :anular do
      transitions from: [:Activado, :Reagendado,:Agendado], to: :Anulado,
          after: [
            :eliminar_job
          ]
    end
  end

  def guardar_movimiento_servicio
    movement_service= MovementService.new
    movement_service.service_service_id = self.id
    movement_service.date_service = self.date_service
    movement_service.code = self.code
    movement_service.appointment_date = self.appointment_date
    movement_service.beneficiary_id = self.beneficiary_id
    movement_service.payment_contracted_product_id = self.payment_contracted_product_id
    movement_service.provider_medico_provider_id = self.provider_medico_provider_id
    movement_service.motive_id = self.motive_id
    movement_service.status = self.status
    movement_service.save
  end

  def verificar_uso_producto_contratado?
    initial_value =InitialValue.find(1)
    movement_service = MovementService.where('"movement_services"."payment_contracted_product_id" = ? AND ("movement_services"."status" = ? OR "movement_services"."status" = ?)', self.payment_contracted_product.id, "Activado", "Reagendado")
    return movement_service.length <  initial_value.max_refech_service

  end

  #Metodo que envia mensaje una vez activado el producto
  def enviar_correo_cliente
    Thread.new do
      @people = self.payment_contracted_product.cliente
      ActivacionProductoMailer.notificarActivacion(@people, self).deliver
      ActiveRecord::Base.connection.close

    end
  end

  #verifica el estatus del servicio, y si es verdadera la condicion habilita el campo de la fecha para editar
  def validar_estatus?
    unless self.appointment_date.nil?
      self.status == "Activado" || self.status == "Reagendado" || self.status == "Usado"
      if self.appointment_date < Date.today && self.status == "Activado"
        return false
      end
    end
  end

  #Metodo buscar medicos asociados a un producto contratado
  def buscar_proveedor_medico
    @provider_provider = self.payment_contracted_product.product_product.provider_provider.id
    @provider_medico_provider = Provider::MedicoProvider.joins(:provider_medico).where('"provider_medico_providers"."provider_provider_id"=? AND "provider_medicos"."status"=?', @provider_provider, "Activo")
    return @provider_medico_provider
  end

  def self.search(search)
    joins(payment_contracted_product:[{ product_product: :product_product },
    :payment_plan => {customer: :people }]).where(' "payment_plans"."number_plan" ilike ? OR lower ("service_services"."status") ilike ?
    OR lower ("service_services"."code") ilike ? OR lower ("product_products"."name") ilike ? OR lower("people"."first_name") ilike ? OR lower("people"."surname") ilike ?',
    "%#{search}%" , "%#{search}%","%#{search}%" ,"%#{search}%", "%#{search}%", "%#{search}%")
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |service|
        csv << service.attributes.values_at(*column_names)
      end
    end
  end

  def self.generar(fechaDesde , fechaHasta)
    where('("service_services"."date_service") >= ? AND ("service_services"."date_service" ) <= ?', "#{fechaDesde}" , "#{fechaHasta}")
  end

  # generar reporte de beneficiarios atendidos (servicios con status usado)
  def self.generarAtendidos(fechaDesde , fechaHasta)
    where('("service_services"."appointment_date") >= ? AND ("service_services"."appointment_date") <= ? ', "#{fechaDesde}" , "#{fechaHasta}")
  end

  def dias_vigencia_servicio
    days_validity_service = InitialValue.find(1).days_validity_service.to_i
    run_at = Date.today+ days_validity_service.to_i
  end

  def anular_servicio
    return self.Activado? || self.Reagendado? ? self.anular! : false
  end

  handle_asynchronously :anular_servicio, run_at: Proc.new {|i| i.dias_vigencia_servicio}

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

  def tiene_fecha
    if self.appointment_date.nil?
      return false
    else
      return true
    end
  end
end
