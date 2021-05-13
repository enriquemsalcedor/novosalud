  class Service::ServicesController < ApplicationController
    before_action :authenticate_user!
    before_action :verificar_permiso
    before_action :permiso_anular
    before_action :permiso_reagendar
    before_action :permiso_cancelar
    before_action :set_service_service, only: [:show, :edit, :update, :destroy, :reagendar, :anular, :cancelar]
    before_action :tittle

  # GET /service/services
  # GET /service/services.json
  def index
    @service_services = Service::Service.all
    respond_to do |format|
      if params[:search]
        format.html { @service_services = Service::Service.search(params[:search]).order("created_at DESC")}
        format.json { @service_services = Service::Service.search(params[:search]).order("created_at DESC")}
        @service_services = Service::Service.search(params[:search]).order("created_at DESC")
        format.xlsx{ render template: 'service/services/index.xlsx', xlsx: 'Servicios' }
      else
        format.html { @service_services = Service::Service.all.order('created_at DESC')}
        format.json { @service_services = Service::Service.all.order('created_at DESC')}
        @service_services = Service::Service.all.order('created_at DESC')
        format.xlsx{ render template: 'service/services/index.xlsx', xlsx: 'Servicios' }
      end
    end
    $motivo =nil
  end

  # GET /service/services/1
  # GET /service/services/1.json
  def show
  end

  # GET /service/services/new
  def new
    $motivo =nil
    @service_service = Service::Service.new
    unless params[:searchProduct].nil?
      @payment_contracted_product= Payment::ContractedProduct.search(params[:searchProduct])
      unless @payment_contracted_product[0].nil?
        @service = Service::Service.find_by(payment_contracted_product_id: @payment_contracted_product[0].id)
      end
      respond_to do |format|
        format.js  { render 'service/services/search_product.js.erb' }
      end
    end
    unless params[:searchBeneficiary].nil? 
      @beneficiary = Beneficiary.searchBeneficiary(params[:searchBeneficiary],params[:search_type_identification])
      respond_to do |format|
        format.js  { render 'service/services/search_beneficiary.js.erb' }
      end
    end
  end

  # GET /service/services/1/edit
  def edit
    @service_service = Service::Service.find(params[:id])
    @provider_medico_provider= Provider::MedicoProvider.where(service_service_id: params[:id])
    @provider_medico_provider = Provider::MedicoProvider.all
    @service_service.motive_id= nil
    @motive= Motive.all

  end

  # POST /service/services
  # POST /service/services.json
  def create
    if params[:service_service][:appointment_date] !=""
      params[:service_service][:status]="Agendado"
    end
    @service_service = Service::Service.new(service_service_params)
    @service_service.date_service =  Date.today
    @service_service.user_created_id=  current_user.id
    @service_service.user_updated_id=  current_user.id
   respond_to do |format|
    if @service_service.save
      if  @service_service.payment_contracted_product.may_activar?
        @service_service.payment_contracted_product.activar!
      end
      format.html { redirect_to  new_service_service_path , notice: 'Se creó el servicio exitosamente.' }
      format.json { render :show, status: :created, location: @service_service }
    else
      format.html { render :new }
      format.js { render json: @service_service.errors, status: :unprocessable_entity }

    end
  end
end

  # PATCH/PUT /service/services/1
  # PATCH/PUT /service/services/1.json
  def update
    @service_service.user_created_id=  current_user.id
    @service_service.user_updated_id=  current_user.id
    if $motivo=="atender"
      $motivo =nil
      if @service_service.tiene_fecha == false
        respond_to do |format|
          @service_service.atender!
          if @service_service.payment_contracted_product.agotar!
            @service_service.payment_contracted_product.update(:user_updated_id => current_user.id)
          end
          session[:atender] = false
          @service_service.update(service_service_params)
          @service_service.guardar_movimiento_servicio
          format.html { redirect_to clinic_pending_date_path,  notice: "El paciente se ha atendido con éxito." }          
          format.json { head :no_content }
        end
      else
        respond_to do |format|
          @service_service.atender!
          if @service_service.payment_contracted_product.agotar!
            @service_service.payment_contracted_product.update(:user_updated_id => current_user.id)
          end
          session[:atender] = false
          @service_service.update(service_service_params)
          @service_service.guardar_movimiento_servicio
          format.html { redirect_to clinic_clinic_service_path,  notice: "El paciente se ha atendido con éxito." }
          format.json { head :no_content }
        end 
      end  
    elsif $motivo == "cancelar"
      respond_to do |format|
        @service_service.cancelar!
        @service_service.payment_contracted_product.revertir!
        format.html { redirect_to service_service_path,  notice: 'Servicio cancelado exitosamente.' }
        format.json { head :no_content }
      end
      @service_service.update(service_service_params)
      @service_service.guardar_movimiento_servicio
      $motivo =nil
    elsif $motivo == "anular"
      respond_to do |format|
        @service_service.anular!
        @service_service.payment_contracted_product.anular!
        format.html { redirect_to service_service_path,  notice: 'Servicio anulado exitosamente.' }
        format.json { head :no_content }
      end
      @service_service.update(service_service_params)
      @service_service.guardar_movimiento_servicio
      $motivo =nil
    elsif $motivo == "reagendar"
      respond_to do |format|
        if @service_service.verificar_uso_producto_contratado?
          @service_service.reagendar!
          if  @service_service.payment_contracted_product.may_activar?
            if  @service_service.payment_contracted_product.activar!
              @service_service.enviar_correo_cliente
            end
          end
          format.html { redirect_to service_service_path, notice: "Servicio reagendado exitosamente."}
          format.json { head :no_content }
        else
          format.html { redirect_to service_services_url, notice: "El servicio #{@service_service.code} no se puede reagendar, límite máximo de intentos." }
          format.json { head :no_content }
        end
      end
      @service_service.update(service_service_params)
      @service_service.guardar_movimiento_servicio
      $motivo =nil
    end 
  end


  #Metodo que permite reagendar por primera vez un servicio ya creado
  def reagendar
    $motivo = "reagendar"
    redirect_to "/service/services/#{params[:id]}/edit" 
  end

  #Metodo que permite cancelar el servicio ya creado, cambia el status del producto a pagado
  def cancelar
    $motivo = "cancelar"
    redirect_to "/service/services/#{params[:id]}/edit"   
  end

  def report
    $desde = params[:fechaDesde]
    $hasta = params[:fechaHasta]
    $total_servicios_activados=0
    unless params[:fechaDesde].nil? && params[:fechaHasta].nil? || params[:fechaDesde]=="" && params[:fechaHasta]==""
      if params[:fechaDesde].to_date > params[:fechaHasta].to_date 
        @noticia = "La fecha desde debe ser menor a la fecha hasta."
      else
        if $desde!="" && $hasta!=""
         @service_services = Service::Service.generar(params[:fechaDesde],params[:fechaHasta]).order("created_at DESC")
        respond_to do |format|
          @service_services = Service::Service.generar(params[:fechaDesde],params[:fechaHasta]).order("created_at DESC")
          @service_services.each do |service_service|
            $total_servicios_activados = $total_servicios_activados + service_service.payment_contracted_product.price_contracted
          end  
          if params[:fechaDesde]
            format.html { @service_services = Service::Service.generar(params[:fechaDesde],params[:fechaHasta]).order("created_at DESC")}
            format.json { @service_services = Service::Service.generar(params[:fechaDesde],params[:fechaHasta]).order("created_at DESC")}
            @service_services = Service::Service.generar(params[:fechaDesde],params[:fechaHasta]).order("created_at DESC")
            format.xlsx { render template: 'service/services/report', xlsx: 'Servicios Activados'}
            format.pdf { render template:'service/services/report', pdf: 'Reporte', orientation:'Landscape' }
          else
            @service_services = Service::Service.where("DATE(created_at) = ?", Date.today)
            @service_services.each do |service_service|
              $total_servicios_activados = $total_servicios_activados + service_service.payment_contracted_product.price_contracted
            end  
            format.html { @service_services = Service::Service.where("DATE(created_at) = ?", Date.today)}
            format.json { @service_services = Service::Service.where("DATE(created_at) = ?", Date.today)}
            format.xlsx { render template: 'service/services/report', xlsx: 'Servicios Activados'}
            format.pdf { render template:'service/services/report', pdf: 'Reporte' ,orientation:'Landscape', page_size:'A4'}
          end
        end
      else
        @noticia = "No debe dejar las fechas vacías."
      end
    end
  end
end

  #Metodo que permite anular el servicio ya creado, cambia el status del producto a anulado.
  def anular
    $motivo = "anular"
    redirect_to "/service/services/#{params[:id]}/edit"   
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service_service
      @service_service = Service::Service.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_service_params
      params.require(:service_service).permit(
        :date_service,
        :appointment_date,
        :user_created_id,
        :user_updated_id,
        :beneficiary_id,
        :provider_medico_provider_id,
        :motive_id,
        :payment_contracted_product_id,
        :status,
        :observation
        )
    end

    def tittle
      @titulobanner =  "Activación de Producto"
    end

  end
