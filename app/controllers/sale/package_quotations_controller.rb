class Sale::PackageQuotationsController < ApplicationController
  before_action :set_sale_package_quotation, only: [:show, :edit, :update, :destroy]
  before_action :obtenerQuotation, only: [:create]


  # GET /sale/package_quotations
  # GET /sale/package_quotations.json
  def index
    @sale_package_quotations = Sale::PackageQuotation.all
  end

  # GET /sale/package_quotations/1
  # GET /sale/package_quotations/1.json
  def show
  end

  # GET /sale/package_quotations/new
  def new
    @sale_package_quotation = Sale::PackageQuotation.new
  end

  # GET /sale/package_quotations/1/edit
  def edit
  end

  # POST /sale/package_quotations
  # POST /sale/package_quotations.json
  def create
    @sale_package_quotation = Sale::PackageQuotation.new(sale_package_quotation_params)
    if user_signed_in?
      @sale_package_quotation.user_created_id = current_user.id
    end
    @sale_package_quotation.colection_package_id = $paqueteid
    @sale_package_quotation.sale_quotation_id = session[:user_car]
    @existepaquete = Sale::PackageQuotation.find_by(colection_package_id: $paqueteid, sale_quotation_id: session[:user_car])
    if @existepaquete.nil?
      respond_to do |format|
        if @sale_package_quotation.save!
          format.html { redirect_to '/promotions', notice: 'Se ha añadido satisfactoriamente este paquete a la cotización' }
          format.json { render :show, status: :created, location: @sale_package_quotation }
        else
          format.html { render :new }
          format.json { render json: @sale_package_quotation.errors, status: :unprocessable_entity }
        end
      end
    else
      @cantidad = @sale_package_quotation.quantity  + @existepaquete.quantity
      respond_to do |format|
        if @existepaquete.update(:quantity => @cantidad)
          if user_signed_in?
            @existepaquete.update(:user_updated_id => current_user.id)
          end
          format.html { redirect_to '/promotions', notice: 'Se ha añadido satisfactoriamente este paquete a la cotización' }
        end
      end
    end
  end

  # PATCH/PUT /sale/package_quotations/1
  # PATCH/PUT /sale/package_quotations/1.json
  def update
    @sale_package_quotation.user_updated_id = current_user.id
    respond_to do |format|
      if @sale_package_quotation.update(sale_package_quotation_params)
        format.html { redirect_to @sale_package_quotation, notice: 'Se ha actualizado satisfactoriamente este paquete en la cotización.' }
        format.json { render :show, status: :ok, location: @sale_package_quotation }
        format.js   { render :layout => false }
      else
        format.html { render :edit }
        format.json { render json: @sale_package_quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  def actualizar_cantidad

    @package = Sale::PackageQuotation.find(params[:id])
    respond_to do |format|
      if @package.update(:quantity => params[:quantity])
        unless current_user.nil?
          @package.update(:user_updated_id => current_user.id)
        end
        @total = "%.2f" % (@package.quantity * @package.colection_package.total_amount)
        format.js { render "sale/package_quotations/actualizar_precio.js.erb"}
      end
    end
  end

  # DELETE /sale/package_quotations/1
  # DELETE /sale/package_quotations/1.json
  def destroy
    @quotation = @sale_package_quotation.sale_quotation
    @sale_package_quotation.destroy
    respond_to do |format|
      format.html { redirect_to sale_package_quotations_url, notice: 'Se ha eliminado satisfactoriamente este paquete en la cotización.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_package_quotation
      @sale_package_quotation = Sale::PackageQuotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_package_quotation_params
      params.require(:sale_package_quotation).permit(:colection_package_id, :sale_quotation_id, :quantity)
    end
    
    def obtenerQuotation
      unless current_user.nil?
        @sale_quotation = Sale::Quotation.find_by(user_id: current_user.id, status: :En_cotizacion)
        unless @sale_quotation.nil?
          session[:user_car] =  @sale_quotation .id
        else
          #@sale_quotation = Sale::Quotation.new
          @sale_quotation = Sale::Quotation.create(:user_id => current_user.id, :user_created_id => current_user.id)
          session[:user_car] =  @sale_quotation.id
        end
      else
        @cotizacion_temporal = Sale::Quotation.find_by(ip_quotation: request.remote_ip, user_id: nil)  
        unless @cotizacion_temporal.nil?
          session[:user_car] =  @cotizacion_temporal.id
        else
          @cotizacion_temporal = Sale::Quotation.create(:ip_quotation => request.remote_ip)
          session[:user_car] =  @cotizacion_temporal.id
        end
      end
   end
  end
