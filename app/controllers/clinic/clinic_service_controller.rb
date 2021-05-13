class Clinic::ClinicServiceController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :activar
  before_action :consultar
  before_action :permiso_atender
  before_action :set_clinic_clinic_service, only: [:atender]
  before_action :tittle

  def index
    @clinic_clinic_service ||= []
    @employee = Employee.find_by(user_id: current_user.id)
    unless @employee.nil?
      if @employee.provider_provider_id.nil?
        @clinic_clinic_service = Service::Service.where('"status" in (?) and "appointment_date" is not null', ["Activado","Reagendado"])
        respond_to do |format|
          format.html { @clinic_clinic_service = Service::Service.where('"status" in (?) and "appointment_date" is not null', ["Reagendado","Agendado"])}
          format.json { @clinic_clinic_service = Service::Service.where('"status" in (?) and "appointment_date" is not null', ["Reagendado","Agendado"])}
          @clinic_clinic_service = Service::Service.where('"status" in (?) and "appointment_date" is not null', ["Reagendado","Agendado"])
          format.xlsx{ render template: 'clinic/clinic_service/index.xlsx', xlsx: 'Citas Agendadas' }
        end
      else   
        id_productos = Payment::ContractedProduct.joins(:product_product).where(product_products: {provider_provider_id: @employee.provider_provider_id}).pluck(:id)
        unless id_productos.empty?
          @clinic_clinic_service = Service::Service.where('"payment_contracted_product_id" in (?) and "status" in (?) and "appointment_date" is not null',id_productos, ["Activado","Reagendado"])
          respond_to do |format|
            format.html { @clinic_clinic_service = Service::Service.where('"payment_contracted_product_id" in (?) and "status" in (?) and "appointment_date" is not null',id_productos, ["Reagendado","Agendado"])}
            format.json { @clinic_clinic_service = Service::Service.where('"payment_contracted_product_id" in (?) and "status" in (?) and "appointment_date" is not null',id_productos, ["Reagendado","Agendado"])}
            @clinic_clinic_service = Service::Service.where('"status" in (?) and "appointment_date" is not null', ["Reagendado","Agendado"])
            format.xlsx{ render template: 'clinic/clinic_service/index.xlsx', xlsx: 'Citas Agendadas' }
          end
        end
      end
    end
    $motivo =nil
  end

  def tittle
    @titulobanner =  "Citas Agendadas"
  end

  def atender
    $motivo = "atender"
    session[:atender] = true
    redirect_to "/service/services/#{params[:id]}/edit"   
  end

  def report
    $service_services

    $desde = params[:fechaDesde]
    $hasta = params[:fechaHasta]
    $total_servicios_atendidos=0
    unless params[:fechaDesde].nil? && params[:fechaHasta].nil?
      if params[:fechaDesde]!="" && params[:fechaHasta]!=""
        if params[:fechaDesde].to_date > params[:fechaHasta].to_date 
          @noticia = "La fecha desde debe ser menor a la fecha hasta."
        else
          unless current_user.nil?
            @employee = Employee.find_by(user_id: current_user.id)
            unless @employee.nil?
              id_productos = Payment::ContractedProduct.joins(:product_product).where(product_products: {provider_provider_id: @employee.provider_provider_id}).pluck(:id)
              if id_productos.empty?
                respond_to do |format|
                  if params[:fechaDesde]
                    @service_services = Service::Service.generarAtendidos(params[:fechaDesde],params[:fechaHasta]).where("status = ? " , "Usado" )

                    @service_services.each do |service_service|
                      $total_servicios_atendidos = $total_servicios_atendidos + service_service.payment_contracted_product.price_contracted
                    end  

                    format.html { @service_services = Service::Service.generarAtendidos(params[:fechaDesde],params[:fechaHasta]).where("status = ? " , "Usado" )}
                    format.json { @service_services = Service::Service.generarAtendidos(params[:fechaDesde],params[:fechaHasta]).where("status = ? " , "Usado" )}
                    format.xlsx{ render template: 'clinic/clinic_service/report.xlsx', xlsx: 'Beneficiarios Atendidos desde el '+params[:fechaDesde]+' hasta el '+params[:fechaHasta] }
                    format.pdf { render template:'clinic/clinic_service/report', pdf: 'Beneficiarios Atendidos desde el '+params[:fechaDesde]+' hasta el '+params[:fechaHasta], title: 'Beneficiarios Atendidos desde el '+params[:fechaDesde]+' hasta el '+params[:fechaHasta], orientation:'Landscape' }
                  else
                    @service_services = Service::Service.where("DATE(created_at) = ? AND  status = ? ", Date.today  , "Usado" )

                    @service_services.each do |service_service|
                      $total_servicios_atendidos = $total_servicios_atendidos + service_service.payment_contracted_product.price_contracted
                    end  

                    format.html { @service_services = Service::Service.where("DATE(created_at) = ? AND  status = ? ", Date.today  , "Usado" )}
                    format.json { @service_services = Service::Service.where("DATE(created_at) = ? AND  status = ? ", Date.today  , "Usado" )}
                    format.xlsx{ render template: 'clinic/clinic_service/report.xlsx', xlsx: 'Beneficiarios Atendidos desde el '+params[:fechaDesde]+' hasta el '+params[:fechaHasta] }
                    format.pdf { render template:'clinic/clinic_service/report', pdf: 'Beneficiarios Atendidos desde el '+params[:fechaDesde]+' hasta el '+params[:fechaHasta], title: 'Beneficiarios Atendidos desde el '+params[:fechaDesde]+' hasta el '+params[:fechaHasta], orientation:'Landscape' }
                  end
                end
              else
                respond_to do |format|
                  if params[:fechaDesde]
                    @service_services = Service::Service.generarAtendidos(params[:fechaDesde],params[:fechaHasta]).where('"payment_contracted_product_id" in (?) and "status" in (?)',id_productos, "Usado")

                    @service_services.each do |service_service|
                      $total_servicios_atendidos = $total_servicios_atendidos + service_service.payment_contracted_product.price_contracted
                    end  

                    format.html { @service_services = Service::Service.generarAtendidos(params[:fechaDesde],params[:fechaHasta]).where('"payment_contracted_product_id" in (?) and "status" in (?)',id_productos, "Usado")}
                    format.json { @service_services = Service::Service.generarAtendidos(params[:fechaDesde],params[:fechaHasta]).where('"payment_contracted_product_id" in (?) and "status" in (?)',id_productos, "Usado")}
                    format.xlsx{ render template: 'clinic/clinic_service/report.xlsx', xlsx: 'Beneficiarios Atendidos desde el '+params[:fechaDesde]+' hasta el '+params[:fechaHasta] }
                    format.pdf { render template:'clinic/clinic_service/report', pdf: 'Beneficiarios Atendidos desde el '+params[:fechaDesde]+' hasta el '+params[:fechaHasta], title: 'Beneficiarios Atendidos desde el '+params[:fechaDesde]+' hasta el '+params[:fechaHasta], orientation:'Landscape' }
                  else
                    @service_services = Service::Service.where("DATE(created_at) = ? AND  status = ? and payment_contracted_product_id in (?) ", Date.today  , "Usado", id_productos )

                    @service_services.each do |service_service|
                      $total_servicios_atendidos = $total_servicios_atendidos + service_service.payment_contracted_product.price_contracted
                    end  

                    format.html { @service_services = Service::Service.where("DATE(created_at) = ? AND  status = ? and payment_contracted_product_id in (?) ", Date.today  , "Usado", id_productos )}
                    format.json { @service_services = Service::Service.where("DATE(created_at) = ? AND  status = ? and payment_contracted_product_id in (?) ", Date.today  , "Usado", id_productos )}
                    format.xlsx{ render template: 'clinic/clinic_service/report.xlsx', xlsx: 'Beneficiarios Atendidos desde el '+params[:fechaDesde]+' hasta el '+params[:fechaHasta] }
                    format.pdf { render template:'clinic/clinic_service/report', pdf: 'Beneficiarios Atendidos desde el '+params[:fechaDesde]+' hasta el '+params[:fechaHasta], title: 'Beneficiarios Atendidos desde el '+params[:fechaDesde]+' hasta el '+params[:fechaHasta], orientation:'Landscape' }
                  end
                end
              end
            end
          else
            @noticia = "No debe dejar las fechas vacías."
          end
        end
      end
    end

  end

  def report_active
    $desde = params[:fechaDesde]
    $hasta = params[:fechaHasta]
    $total_servicios_activados = 0
    unless params[:fechaDesde].nil? && params[:fechaHasta].nil?
      if params[:fechaDesde]!="" && params[:fechaHasta]!=""
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
                format.xlsx { render template: 'service/services/report', xlsx: 'Servicios activados'}
                format.pdf { render template:'service/services/report', pdf: 'Servicios activados', orientation:'Landscape' }
              else
                @service_services = Service::Service.where("DATE(created_at) = ?", Date.today)
                @service_services.each do |service_service|
                  $total_servicios_activados = $total_servicios_activados + service_service.payment_contracted_product.price_contracted
                end  
                format.html { @service_services = Service::Service.where("DATE(created_at) = ?", Date.today)}
                format.json { @service_services = Service::Service.where("DATE(created_at) = ?", Date.today)}
                format.xlsx { render template: 'service/services/report', xlsx: 'Servicios activados'}
                format.pdf { render template:'service/services/report', pdf: 'Servicios activados' ,orientation:'Landscape', page_size:'A4'}
              end
            end
          else
            @noticia = "No debe dejar las fechas vacías."
          end
        end
      end
    end
  end

  def pending_date
    @clinic_clinic_service ||= []
    @employee = Employee.find_by(user_id: current_user.id)
    unless @employee.nil?
      if @employee.provider_provider_id.nil?
        @clinic_clinic_service = Service::Service.where('"status" in (?) and "appointment_date" is null', ["Activado","Reagendado"])
        respond_to do |format|
          format.html { @clinic_clinic_service = Service::Service.where('"status" in (?) and "appointment_date" is null', ["Activado","Reagendado"])}
          format.json { @clinic_clinic_service = Service::Service.where('"status" in (?) and "appointment_date" is null', ["Activado","Reagendado"])}
          @clinic_clinic_service = Service::Service.where('"status" in (?) and "appointment_date" is null', ["Activado","Reagendado"])
          format.xlsx{ render template: 'clinic/clinic_service/pending_date.xlsx', xlsx: 'Citas por Agendar' }
        end
      else   
        id_productos = Payment::ContractedProduct.joins(:product_product).where(product_products: {provider_provider_id: @employee.provider_provider_id}).pluck(:id)
        unless id_productos.empty?
          @clinic_clinic_service = Service::Service.where('"payment_contracted_product_id" in (?) and "status" in (?) and "appointment_date" is null',id_productos, ["Activado","Reagendado"])
          respond_to do |format|
            format.html { @clinic_clinic_service = Service::Service.where('"payment_contracted_product_id" in (?) and "status" in (?) and "appointment_date" is null',id_productos, ["Activado","Reagendado"])}
            format.json { @clinic_clinic_service = Service::Service.where('"payment_contracted_product_id" in (?) and "status" in (?) and "appointment_date" is null',id_productos, ["Activado","Reagendado"])}
            @clinic_clinic_service = Service::Service.where('"payment_contracted_product_id" in (?) and "status" in (?) and "appointment_date" is null',id_productos, ["Activado","Reagendado"])
            format.xlsx{ render template: 'clinic/clinic_service/pending_date.xlsx', xlsx: 'Citas por Agendar' }
          end        
        end
      end
    end
  end


  private
  def edit
    @clinic_clinic_service = Service::Service.find(params[:id])
  end

  private
  def edit
    @clinic_clinic_service = Service::Service.find(params[:id])
  end

  def set_clinic_clinic_service
    @clinic_clinic_service = Service::Service.find(params[:id])
  end
end
