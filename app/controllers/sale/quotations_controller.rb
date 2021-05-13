class Sale::QuotationsController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :modificar
  before_action :consultar
  before_action :permiso_pagar
  before_action :title
  before_action :set_sale_quotation, only: [:show, :edit, :update, :destroy, :pagar, :reactivar, :cotizar]
  before_action :eliminarVariableGlobales, only: [:new]
  Sale::ProductQuotation

  # GET /sale/quotations
  # GET /sale/quotations.json
  def index
     @payment_transference = Payment::Transference.all
    respond_to do |format|
      if params[:search]
        format.html { @quotations = Sale::Quotation.cotizadas.search(params[:search]).order("payment_transferences.sale_quotation_id ASC")}
        format.json { @quotations = Sale::Quotation.cotizadas.search(params[:search]).order("payment_transferences.sale_quotation_id ASC") }
        @quotations1 = Sale::Quotation.cotizadas.order('payment_transferences.sale_quotation_id ASC')
        @quotations = @quotations1.select { |a| @payment_transference = Payment::Transference.where(sale_quotation_id: a.id) != 0 }
        format.xlsx{ render template: 'sale/quotations/transferencias.xlsx',xlsx: 'Cotizaciones Pagadas vía Transferencia Electrónica'}
        format.pdf  { render template: 'sale/quotations/transferencias.pdf', pdf: 'Cotizaciones Pagadas vía Transferencia Electrónica'}
      else
        format.html { @quotations = Sale::Quotation.cotizadas.order('payment_transferences.sale_quotation_id ASC')}
        format.json { @quotations = Sale::Quotation.cotizadas.order('payment_transferences.sale_quotation_id ASC')}
        @quotations1 = Sale::Quotation.cotizadas.order('payment_transferences.sale_quotation_id ASC')
        @quotations = @quotations1.select { |a| @payment_transference.detect{|pt| pt.sale_quotation_id == a.id}}
        format.xlsx{ render template: 'sale/quotations/transferencias.xlsx', xlsx: 'Cotizaciones Pagadas vía Transferencia Electrónica' }
        format.pdf  { render template: 'sale/quotations/transferencias.pdf', pdf: 'Cotizaciones Pagadas vía Transferencia Electrónica'}
      end
    end
  end

  def reporte
    @payment_transference = Payment::Transference.all
    respond_to do |format|
      if params[:search]
        @quotations = Sale::Quotation.cotizadas.order('payment_transferences.sale_quotation_id ASC')
        format.xlsx{ render template: 'sale/quotations/reporte.xlsx',xlsx: 'Cotizaciones'}
      else
        @quotations = Sale::Quotation.cotizadas.order('payment_transferences.sale_quotation_id ASC')
        format.xlsx{ render template: 'sale/quotations/reporte.xlsx',xlsx: 'Cotizaciones'}
      end
    end
  end

  # GET /sale/quotations/1
  # GET /sale/quotations/1.json
  def show
    @product_quotations = Sale::ProductQuotation.where(sale_quotation_id: params[:id])
    @package_quotations = Sale::PackageQuotation.where(sale_quotation_id: params[:id])
  end

  # GET /sale/quotations/new
  def new
    @sale_quotation = Sale::Quotation.new
    @package= Colection::Package.all
    @sale_package_quotation = Sale::PackageQuotation.new
    @sale_product_quotation = Sale::Quotation.new
  end

  # GET /sale/quotations/1/edit
  def edit
    $quotation = Sale::Quotation.find(params[:id])
    @sale_package_quotation = Sale::PackageQuotation.new
    @package_quotations = Sale::PackageQuotation.where(sale_quotation_id: params[:id])
    @package= Colection::Package.all
    @product_quotations = Sale::ProductQuotation.where(sale_quotation_id: params[:id])

  end

  def pay
    $quotation_id = params[:id]
    @quotation = Sale::Quotation.find_by(id: params[:id])
    unless @quotation.user.customer.nil?
      @costumer = @quotation.user.customer.id
    else
      @company = @quotation.user.company.id
    end
    @product_quotation = Sale::ProductQuotation.new
    @product_quotations = Sale::ProductQuotation.where(sale_quotation_id: params[:id])
    @package_quotations = Sale::PackageQuotation.where(sale_quotation_id: params[:id])
    @payment_plan = Payment::Plan.new
    @payment_transference = Payment::Transference.find_by(sale_quotation_id: @quotation.id)
    @method_payment = MethodPayment.find_by(name: "Transferencia electrónica")
    @monto = @quotation.sumar_montos
    @quotation_id = params[:id]
  end

  def reactivate

    respond_to do |format|
      if params[:search]
        format.html { @quotations = Sale::Quotation.where('status = ?' , "Vencida").search(params[:search]).order("created_at DESC , status DESC")}
        format.json { @quotations = Sale::Quotation.where('status = ?' , "Vencida").search(params[:search]).order("created_at DESC , status DESC")}
      else
        format.html { @quotations = Sale::Quotation.where('status = ?' , "Vencida").order('created_at DESC , status DESC')}
        format.json { @quotations = Sale::Quotation.where('status = ?' , "Vencida").order('created_at DESC , status DESC')}
      end
    end
  end

  # POST /sale/quotations
  # POST /sale/quotations.json
  def create
    @sale_quotation = Sale::Quotation.new(sale_quotation_params)

    respond_to do |format|
      if @sale_quotation.save
        format.html { redirect_to @sale_quotation, notice: 'Cotización creada con éxito.' }
        format.json { render :show, status: :created, location: @sale_quotation }
      else
        format.html { render :new }
        format.json { render json: @sale_quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sale/quotations/1
  # PATCH/PUT /sale/quotations/1.json
  def update
    respond_to do |format|
      if @sale_quotation.update(sale_quotation_params)
        if  @sale_quotation.may_reactivar?
          @sale_quotation.reactivar!
        end
        format.html { redirect_to sale_reactivar_path, notice: 'Cotización actualizada con éxito.' }
        format.json { render :show, status: :ok, location: '/sale/reactivar' }
      else
        format.html { render :edit }
        format.json { render json: @sale_quotation.errors, status: :unprocessable_entity }
      end     
    end
  end

  # DELETE /sale/quotations/1
  # DELETE /sale/quotations/1.json
  def destroy
    @sale_quotation.destroy
    respond_to do |format|
      format.html { redirect_to sale_quotations_url, notice: 'Cotización eliminada con éxito' }
      format.json { head :no_content }
    end
  end


  def reactivar
    if @sale_quotation.reactivar!
      @sale_quotation.vencer_cotizacion
      @sale_quotation.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to @sale_quotation, notice: "Se ha reactivado con éxito la cotización."}
        format.json { head :no_content }
      end
    end
  end

  def pagar
    if @sale_quotation.pagar!
      @sale_quotation.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to  @sale_quotation, notice: "Se pagó con éxito la cotización." }
        format.json { head :no_content }
      end
    end
  end

  def cotizar
    @novosalud = Organization.find_by(:id => 1)
    unless current_user.nil?
      unless session[:cart].nil? or session[:cart] == ''
        @cotizacion = Sale::Quotation.find(session[:cart])
        @package_quotations = @cotizacion.sale_package_quotation.order(id: :asc)
        @product_quotations = @cotizacion.sale_product_quotations.order(id: :asc)

        if @cotizacion.cotizar!
          @cotizacion = Sale::Quotation.where(user_id: current_user.id, status: :Vigente).last        
          @cotizacion.verificar_cantidad_maxima
          @cotizacion.vencer_cotizacion
          @cotizacion.update(:user_updated_id => current_user.id)

          respond_to do |format|
          format.html { redirect_to  '/', notice: "Su compra ha sido formalizada exitosamente" }
          format.json { head :no_content }
          format.js { head :no_content }
          format.pdf  { render template: 'sale/quotations/cotizacion.pdf', pdf: 'Cotizacion'}
        end
      end
      
      end
    else
      redirect_to decision_path
    end
  end

  def comprobante
    @novosalud = Organization.find_by(:id => 1)
    @cotizacion = Sale::Quotation.find(session[:cart])
    @package_quotations = @cotizacion.sale_package_quotation.order(id: :asc)
    @product_quotations = @cotizacion.sale_product_quotations.order(id: :asc)
    respond_to do |format|
      format.html { redirect_to  '/', notice: "Su compra ha sido formalizada exitosamente" }
      format.json { head :no_content }
      format.pdf  { render template: 'sale/quotations/cotizacion.pdf', pdf: 'Cotizacion'}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_sale_quotation
      @sale_quotation = Sale::Quotation.find(params[:id])
    end

    def title
      @titulobanner =  I18n.t ('.general.models.quotations')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_quotation_params
      params.require(:sale_quotation).permit(
        :quoting_number,
        :status,
        :user_id,
        :valid_since,
        :valid_until,
        :user_created_id,
        :user_updated_id,
        :ip_quotation
        )
    end

    def eliminarVariableGlobales
      $quotation =nil
    end

end
