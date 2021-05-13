class HomeController < ApplicationController
  before_action :title
  before_action :set_organization
  before_action :set_quotation
  before_action :set_product, only: [:details]
  before_action :verificar_usuario
  before_action :set_package, only: [:promotion]
  layout :set_layout
  add_breadcrumb "Inicio", :root_path
  def index
    session[:controller_layout] = params[:controller]
    session[:layout_action] = params[:action]
    @titulobanner= "Nuestros Productos"
    search(params[:search], params[:param_id_speciality])
  end

  def authorize_action
    if !(current_user.can?(:admin) ||
      current_user.eql?(@objeto.created_by) ||
      current_user.can?(params[:action].to_sym, @objeto))
      render 'errors/403', status: 403, layout: 'application'
    end
  end

  #despues de verificar si existen productos de distintos segmentos redirecciona
  def redireccionamiento_verificar
    @cotizacion_temporal = Sale::Quotation.find_by(ip_quotation: request.remote_ip, user_id: nil)
    @product_quotations = @cotizacion_temporal.sale_product_quotations.order(id: :asc)
    $producto = 0
    if params[:cliente]== "persona"
      @product_quotations.each do |product|
        if (product.product_product.category == 'PYMES')
          $producto = 1
        end  
      end
      if $producto > 0
        redirect_to message_path(:cliente => "persona")
      else 
        redirect_to new_user_session_path(:cliente => "persona")
      end
    else
      @product_quotations.each do |product|
        if (product.product_product.category == 'Individual')
          $producto = 1
        end  
      end
      if $producto > 0
        redirect_to message_path(:cliente => "empresa")
      else 
        redirect_to new_user_session_path(:cliente => "empresa")
      end
    end  
  end



  def list
    if params[:param_id_speciality]=='0' 
      params[:param_id_speciality]=''
    end
    @product_quotation = Sale::ProductQuotation.last
    @titulobanner= "Nuestros Servicios"

    respond_to do |format|
     if params[:search] && params[:param_id_speciality]==""
      format.html { @products = Product::Product.no_cero.activo.individual.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      format.json { @products = Product::Product.no_cero.activo }
      add_breadcrumb "Servicios", "/list"
    elsif params[:search]=="" && params[:param_id_speciality]
      format.html { @products = Product::Product.no_cero.activo.individual.search_product_by_speciality(params[:param_id_speciality]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      format.json { @products = Product::Product.no_cero.activo }
      add_breadcrumb "Servicios", "/list"
    elsif  params[:search] && params[:param_id_speciality] && params[:param_id_speciality]!=0
      format.html { @products = Product::Product.no_cero.activo.individual.search(params[:search]).search_product_by_speciality(params[:param_id_speciality]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      format.json { @products = Product::Product.no_cero.activo }
      add_breadcrumb "Servicios", "/list"
    else
     format.html { @products = Product::Product.no_cero.activo.individual.order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
     format.json { @products = Product::Product.no_cero.activo }
     add_breadcrumb "Servicios", "/list"
   end   
 end
end


def list_search
  if $search
    params[:search] = $search 
    $search = nil
  end
  if $param_id_speciality
    params[:param_id_speciality] = $param_id_speciality 
    $param_id_speciality = nil
  end
  @product_quotation = Sale::ProductQuotation.last
  @titulobanner= "Nuestros Servicios"
  respond_to do |format|
    if params[:param_id_speciality]=='0' 
      params[:param_id_speciality]=''
    end
    if params[:search] && params[:param_id_speciality]==""
      format.html { @products = Product::Product.no_cero.activo.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      format.json { @products = Product::Product.no_cero.activo }
      add_breadcrumb "Servicios", "/list"
    elsif params[:search]=="" && params[:param_id_speciality]
      format.html { @products = Product::Product.no_cero.activo.search_product_by_speciality(params[:param_id_speciality]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      format.json { @products = Product::Product.no_cero.activo }
      add_breadcrumb "Servicios", "/list"
    elsif  params[:search] && params[:param_id_speciality] && params[:param_id_speciality]!=0
      format.html { @products = Product::Product.no_cero.activo.search(params[:search]).search_product_by_speciality(params[:param_id_speciality]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      format.json { @products = Product::Product.no_cero.activo }
      add_breadcrumb "Servicios", "/list"
    else
      format.html { @products = Product::Product.no_cero.activo.order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      format.json { @products = Product::Product.no_cero.activo }
      add_breadcrumb "Servicios", "/list"
    end
  end
end

def plist
  @titulobanner= "Nuestros Productos"
  if params[:param_id_speciality]=='0' 
    params[:param_id_speciality]=''
  end
  respond_to do |format|
    if params[:search] && params[:param_id_speciality]==""
      format.html { @products = Product::Product.no_cero.activo.pymes.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      format.json { @products = Product::Product.no_cero.activo.pymes }
      add_breadcrumb "Servicios", "/list"
    elsif params[:search]=="" && params[:param_id_speciality]
      format.html { @products = Product::Product.no_cero.activo.pymes.search_product_by_speciality(params[:param_id_speciality]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      format.json { @products = Product::Product.no_cero.activo.pymes }
      add_breadcrumb "Servicios", "/list"
    elsif  params[:search] && params[:param_id_speciality] && params[:param_id_speciality]!=0
      format.html { @products = Product::Product.no_cero.activo.pymes.search(params[:search]).search_product_by_speciality(params[:param_id_speciality]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      format.json { @products = Product::Product.no_cero.activo.pymes }
      add_breadcrumb "Servicios", "/list"
    else
     format.html { @products = Product::Product.no_cero.activo.pymes.order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
     format.json { @products = Product::Product.no_cero.activo.pymes }
     add_breadcrumb "Servicios", "/list"
   end
 end
end

def details
  @product_providers = Product::Product.where(id: params[:id])
  @sale_product_quotation = Sale::ProductQuotation.new
  add_breadcrumb "Servicios", "/list"
  add_breadcrumb "#{@product_providers[0].name}", "#{params[:id]}"
  if params[:search]
    $search = params[:search]
  end
  if params[:param_id_speciality]
    $param_id_speciality = params[:param_id_speciality]
  end
  respond_to do |format|
    if params[:search]
      format.html { redirect_to list_search_path, search: "#{params[:search]}", param_id_speciality: "#{params[:param_id_speciality]}" } 
      format.json { @products = Product::Product.no_cero.activo }
      add_breadcrumb "Servicios", "/list"
    else 
      format.html { @products = Product::Product.no_cero.individual.activo.last(4) and @products2 = Product::Product.no_cero.pymes.activo.last(4) }
      format.json { @products = Product::Product.no_cero.activo }
    end
  end
end

def promotion
  @package_products = Colection::PackageProduct.where(colection_package_id: params[:id])
  @package = Colection::Package.find(params[:id])
  @sale_package_quotation = Sale::PackageQuotation.new
  add_breadcrumb "Paquetes y Promociones", "/promotions"
  add_breadcrumb "#{@package.description}", "#{params[:id]}"
  search(params[:search], params[:param_id_speciality])
end

def promotions
  @package_quotation = Sale::PackageQuotation.last
  @titulobanner= "Nuestras Promociones"
  respond_to do |format|
    if params[:search]
      format.html { @packages = Colection::Package.no_cero.activo.individual.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      format.json { @packages = Colection::Package.no_cero.activo.individual.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      add_breadcrumb "Paquetes y Promociones", "/promotions"
    else
      format.html { @packages = Colection::Package.no_cero.activo.individual.order('created_at DESC').paginate(:page => params[:page], :per_page => 12) }
      format.json { @packages = Colection::Package.no_cero.activo.individual.order('created_at DESC').paginate(:page => params[:page], :per_page => 12) }
      add_breadcrumb "Paquetes y Promociones", "/promotions"
    end
  end
end

def pymes_promotions
  @package_quotation = Sale::PackageQuotation.last
  @titulobanner= "Nuestras Promociones"
  respond_to do |format|
    if params[:search]
      format.html { @packages = Colection::Package.no_cero.activo.pymes.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      format.json { @packages = Colection::Package.no_cero.activo.pymes.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 12) }
      add_breadcrumb "Paquetes y Promociones", "/pymes_promotions"
    else
      format.html { @packages = Colection::Package.no_cero.activo.pymes.order('created_at DESC').paginate(:page => params[:page], :per_page => 12) }
      format.json { @packages = Colection::Package.no_cero.activo.pymes.order('created_at DESC').paginate(:page => params[:page], :per_page => 12) }
      add_breadcrumb "Paquetes y Promociones", "/pymes_promotions"
    end
  end
end

def cart
  if user_signed_in?
    @titulobanner= "Mi compra"
    unless session[:cart].nil?
      @package_quotations = session[:cart].sale_package_quotation.order(id: :asc)
      @product_quotations = session[:cart].sale_product_quotations.order(id: :asc)
      @sale_package_quotation = Sale::PackageQuotation.new
      @package= Colection::Package.all
    else
      @noticia = "No ha agregado ningún producto o paquete."
    end
  else
    unless session[:cart].nil?
      @package_quotations = session[:cart].sale_package_quotation.order(id: :asc)
      @product_quotations = session[:cart].sale_product_quotations.order(id: :asc)
      @sale_package_quotation = Sale::PackageQuotation.new
      @package= Colection::Package.all
    else
      @noticia = "No ha agregado ningún producto o paquete."
    end
  end
end

def plan_history
  if user_signed_in?
    require 'will_paginate/array'
    @customer = Customer.find_by(user_id: current_user.id)
    @company = Business::Company.find_by(user_id: current_user.id)
    @titulobanner= "Detalle del plan"
    @plan = Payment::Plan.new
    if params[:search]
      if @company.nil?
        @plan = Payment::Plan.where(customer_id: @customer.id).busqueda(params[:search]).paginate(:page => params[:page], :per_page => 2)
      else
        @plan = Payment::Plan.where(company_id: @company.id).busqueda(params[:search]).paginate(:page => params[:page], :per_page => 2)
      end
    else
      if @company.nil?
        @plan = Payment::Plan.where(customer_id: @customer.id).order(created_at: :desc).paginate(:page => params[:page], :per_page => 2)
      else
        @plan = Payment::Plan.where(company_id: @company.id).order(created_at: :desc).paginate(:page => params[:page], :per_page => 2)
      end
    end
  end

end

def quotation_history
  if user_signed_in?
    require 'will_paginate/array'
    @titulobanner= "Historial de cotizaciones"
    respond_to do |format|
      if params[:search]
        format.html { @quotation = Sale::Quotation.where(user_id: current_user.id , status: :Vigente).busqueda(params[:search]).paginate(:page => params[:page], :per_page => 1)}
        format.json { @quotation = Sale::Quotation.where(user_id: current_user.id , status: :Vigente).busqueda(params[:search]).paginate(:page => params[:page], :per_page => 1)}
      else
        format.html { @quotation = Sale::Quotation.where(user_id: current_user.id , status: :Vigente).paginate(:page => params[:page], :per_page => 1)}
        format.json { @quotation = Sale::Quotation.where(user_id: current_user.id , status: :Vigente).paginate(:page => params[:page], :per_page => 1)}
      end
    end
  end
  search(params[:search], params[:param_id_speciality])

end

def expired_quotation
  if user_signed_in?
    @titulobanner= "Detalle de la cotización vencida"
    @quotation = Sale::Quotation.new
    @quotation = Sale::Quotation.where(user_id: current_user.id, status: :Vencida).order(created_at: :desc).paginate(:page => params[:page], :per_page => 2)
  end
end

def clinics
  session[:controller_layout] = params[:controller]
  session[:layout_action] = params[:action]
  if params[:search]
    $search = params[:search]
  end
  if params[:param_id_speciality]
    $param_id_speciality = params[:param_id_speciality]
  end
  @titulobanner= "Centros Médicos"
  respond_to do |format|
    if params[:search]
      format.html { redirect_to list_search_path, search: "#{params[:search]}", param_id_speciality: "#{params[:param_id_speciality]}" } 
      format.json { @products = Product::Product.no_cero.activo }
    else
      format.html { @provider_providers = Provider::Provider.activo.order('created_at DESC').paginate(:page => params[:page], :per_page => 9) }
      format.json { @provider_providers = Provider::Provider.activo.order('created_at DESC').paginate(:page => params[:page], :per_page => 9) }
      add_breadcrumb "Centros Médicos", "/clinics"
    end
  end
end

def clinics_details
  @provider_providers = Provider::Provider.find(params[:id])
  @sale_product_quotation = Sale::ProductQuotation.new
  add_breadcrumb "Centros Médicos", "/clinics"
  add_breadcrumb "#{@provider_providers.name}", "#{params[:id]}"
  search(params[:search], params[:param_id_speciality])
end

def search(param_search, param_id_speciality)
  if param_search
    $search = param_search
  end
  if params[:param_id_speciality]
    $param_id_speciality = param_id_speciality
  end
  respond_to do |format|
    if params[:search]
      format.html { redirect_to list_search_path, search: "#{param_search}", param_id_speciality: "#{param_id_speciality}" } 
      format.json { @products = Product::Product.no_cero.activo }
      add_breadcrumb "Servicios", "/list"
    else 
      format.html { @products = Product::Product.no_cero.individual.activo.last(4) and @products2 = Product::Product.no_cero.pymes.activo.last(4) }
      format.json { @products = Product::Product.no_cero.activo }
    end
  end
end

def transference
  @quotation = Sale::Quotation.find_by(user_id: current_user.id, status: :Vigente)
  @payment_transference = Payment::Transference.new
  @accounts = Account.activo
end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      if user_signed_in?
        if current_user.customer.nil?
          @product = Product::Product.find_by(id: params[:id], status: "Activo",category: ["PYMES", "Ambas"])
          if @product.nil?
            redirect_to plist_path, alert: "Se ha seleccionado un servicio que no pertenece a su segmento."
          end
        elsif current_user.company.nil?
          @product = Product::Product.find_by(id: params[:id], status: "Activo",category: ["Individual", "Ambas"])
          if @product.nil?
            redirect_to list_path, alert: "Se ha seleccionado un servicio que no pertenece a su segmento."
          end
        end
      else
        @product = Product::Product.find_by(id: params[:id], status: "Activo")
        if @product.nil?
          redirect_to list_path, notice: "Producto no existe"
        end
      end
    end

    def set_quotation
      if user_signed_in?
        session[:cart]= Sale::Quotation.find_by(user_id: current_user.id, status: :En_cotizacion)
      else
        session[:cart] = Sale::Quotation.find_by(ip_quotation: request.remote_ip, status: :En_cotizacion, user_id: nil)
      end
    end

    def title
      @titulobanner =  I18n.t ('.general.attribute.welcome')
    end

    def decision
      #metodo que permite la visualización de la vista decision al momento de comprar sin estar logueado
    end

    def verificar_usuario
      if user_signed_in?
        @user_employee = Employee.find_by user_id: current_user.id
        @user_person = Customer.find_by user_id: current_user.id
        @user_company = Business::Company.find_by user_id: current_user.id
        @user = current_user.client_type
        session[:client_type] = @user
        if session[:layout] == 'admin'
          $client = ''
        end
        if !@user_employee.nil? && session[:layout] == 'application'
          sign_out_and_redirect(current_user)
          $client = ''
          flash.notice = "Usted es un usuario administrativo"
        elsif !@user_employee.nil? && password_change?
          session[:employee_id] = @user_employee.id
          render partial: 'layouts/admin2'
        elsif !@user_employee.nil? && !password_change?
          if !tempory_password_validate?
            session[:employee_id] = @user_employee.id
            redirect_to edit_user_registration_path
          elsif tempory_password_validate?
            sign_out current_user
            redirect_to admin_path
            flash.notice ="Su clave Temporal se vencio, debe solicitarla nuevamente"
          end  
        else
          if $client == "persona"
            if @user_person.nil? && @user== "persona"
              redirect_to new_customer_path
            elsif !@user_person.nil?
              session[:customer_id] = @user_person.id
              index
            else
              session[:layout] = 'application'
              sign_out_and_redirect(current_user)
              flash.alert = "Usted se encuentra registrado como empresa. No puede acceder como individual"
            end
          elsif $client == "empresa"
            if @user_company.nil? && @user== "empresa"
              redirect_to new_business_company_path
            elsif !@user_company.nil?
              session[:company_id] = @user_company.id
              index
            else
              session[:layout] = 'application'
              sign_out_and_redirect(current_user)
              flash.alert ="Usted se encuentra registrado como individual. No puede acceder como empresa"
            end
          end
        end
      else
        if session[:action] == "update" && session[:action_layout] == "admin"
         redirect_to admin_path
         session[:action] = ''
         session[:action_layout] = ''              
        end  
      end
    end

    def set_package
      if user_signed_in?
        if current_user.customer.nil?
          @package = Colection::Package.find_by(id: params[:id], status: "Activo",category: ["PYMES", "Ambas"])
          if @package.nil?
            redirect_to pymes_promotions_path, notice: "Se ha seleccionado una promoción que no pertenece a su segmento."
          end
        elsif current_user.company.nil?
          @package = Colection::Package.find_by(id: params[:id], status: "Activo",category: ["Individual", "Ambas"])
          if @package.nil?
            redirect_to promotions_path, notice: "Se ha seleccionado una promoción que no pertenece a su segmento."
          end
        end
      else
        @package = Colection::Package.find_by(id: params[:id], status: "Activo")
        if @package.nil?
          redirect_to promotions_path, notice: "Paquete no existe"
        end
      end
    end

    def set_layout
      if session[:controller_layout]=='admin'  && session[:layout_action] =='index' 
        if user_signed_in?
          unless @user_company.nil?
            session[:company_id] = @user_company.id
          end
        end
        session[:layout] = 'admin'
      else
        if user_signed_in?
          unless @user_company.nil?
            session[:company_id] = @user_company.id
          end
        end
        session[:layout] = 'application'
      end
    end

    def password_change?
      @start_date = current_user.password_changed_at
      @end_date =  Date.today
      @difference_days = (@end_date.to_date - @start_date.to_date).to_i
      if current_user.temporary_password.nil? && current_user.temporary_password_valid.nil?
        if @difference_days <= 120
          return true
        else
          return false
        end
      elsif current_user.temporary_password == true && current_user.temporary_password_valid == true
        return false
      else
        return false
      end
    end

    def tempory_password_validate?
      if current_user.temporary_password == true && current_user.temporary_password_valid == false
        return true 
      end       
    end

    def set_organization
      @organization = Organization.find(1)
    end
  end
