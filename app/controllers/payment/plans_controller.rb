class Payment::PlansController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :activar
  before_action :consultar
  before_action :title
  before_action :set_payment_plan, only: [:show, :edit, :update, :destroy]

  # GET /payment/plans
  # GET /payment/plans.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @payment_plans = Payment::Plan.search(params[:search]).order("created_at DESC")}
        format.json { @payment_plans = Payment::Plan.search(params[:search]).order("created_at DESC")}
      else
        format.html { @payment_plans = Payment::Plan.all.order('created_at DESC')}
        format.json { @payment_plans = Payment::Plan.all.order('created_at DESC')}
        @payment_plans = Payment::Plan.all.order('created_at DESC')
        format.xlsx{ render template: 'payment/plans/index.xlsx', xlsx: 'Órdenes de Compra' }
      end
    end
  end

  # GET /payment/plans/1
  # GET /payment/plans/1.json
  def show
    @product_quotations = Sale::ProductQuotation.where(sale_quotation_id: @payment_plan.sale_quotation_id)
    @package_quotations = Sale::PackageQuotation.where(sale_quotation_id: @payment_plan.sale_quotation_id)
    @buscar_precio = Payment::ContractedProduct.select(:price_contracted,:plan_id,:product_product_id).where(plan_id: @payment_plan.id).distinct

  end

  # GET /payment/plans/new
  def new
    @payment_plan = Payment::Plan.new
  end

  # GET /payment/plans/1/edit
  def edit
  end

  # POST /payment/plans
  # POST /payment/plans.json
  def create
    @payment_plan = Payment::Plan.new(payment_plan_params)
    @payment_plan.user_created_id = current_user.id
    #Se verifica si bank_id,reference estan vacios y el tipo de pago no es efectivo
    unless params[:payment_plan][:bank_id].empty? && params[:payment_plan][:reference].empty? && params[:payment_plan][:method_payment_id] != "4"
      #Se verifica si bank_id estan vacios y el tipo de pago no es efectivo    
      unless params[:payment_plan][:bank_id].empty? && params[:payment_plan][:method_payment_id] != "4"
        #Se verifica si bank_id estan vacios y el tipo de pago no es efectivo 
        unless params[:payment_plan][:reference].empty? && params[:payment_plan][:method_payment_id] != "4"         
          respond_to do |format|
            if @payment_plan.save
              format.html { redirect_to sale_quotations_path, notice: "Se creó con éxito la orden de compra número #{@payment_plan.number_plan}." }
              format.json { render :show, status: :created, location: @payment_plan }
            else
              format.html { render :new }
              format.json { render json: @payment_plan.errors, status: :unprocessable_entity }
            end
          end
        else
          redirect_to "/sale/quotations/#{$quotation_id}/pay"
          flash[:errors_reference] = "Por favor, intraduzca número de referencia."
        end  
      else
        redirect_to "/sale/quotations/#{$quotation_id}/pay"
        flash[:errors_banks] = "Por favor, seleccione banco."
      end
    else
      redirect_to "/sale/quotations/#{$quotation_id}/pay"
      flash[:errors_banks] = "Por favor, seleccione banco."
      flash[:errors_reference] = "Por favor, intraduzca número de referencia."
    end  
  end

  # PATCH/PUT /payment/plans/1
  # PATCH/PUT /payment/plans/1.json
  def update
    @payment_plan.user_updated_id = current_user.id
    respond_to do |format|
      if @payment_plan.update(payment_plan_params)
        format.html { redirect_to @payment_plan, notice: 'Se actualizó con éxito la orden de compra.' }
        format.json { render :show, status: :ok, location: @payment_plan }
      else
        format.html { render :edit }
        format.json { render json: @payment_plan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payment/plans/1
  # DELETE /payment/plans/1.json
  def destroy
    @payment_plan.destroy
    respond_to do |format|
      format.html { redirect_to payment_plans_url, notice: 'Se eliminó con éxito la orden de compra.' }
      format.json { head :no_content }
    end
  end

  def cierre
    unless params[:fecha].nil?
      $fecha=params[:fecha].to_date
    else
      $fecha=Date.today
      params[:fecha]=$fecha
      $fecha=params[:fecha].to_date
    end
    if params[:fecha]!=""
      if $fecha.to_date <= Date.today 
        @payment_plans = Payment::Plan.order(id: :asc).where("DATE(created_at) = ?", $fecha)
        @method_payment = MethodPayment.unscoped.all
        @total_general = @payment_plans.sum(:total_amount)
        @buscar_precio = Payment::ContractedProduct.order(plan_id: :asc).select(:plan_id,:price_contracted,:product_product_id).where("DATE(created_at) = ?", $fecha).distinct
        @org = Organization.find(1)
        respond_to do |format|
          format.html
          format.csv { send_data @payment_plans.to_csv }
          format.xls
          format.pdf {render template:'payment/plans/cierre', pdf: 'Cierre de Caja del '+params[:fecha], title: 'Cierre de Caja del '+params[:fecha]}
        end
      else
        @noticia="Debe ser menor o igual a la fecha de hoy"
      end
    else
      @noticia="Debe agregar una Fecha"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_plan
      @payment_plan = Payment::Plan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_plan_params
      params.require(:payment_plan).permit(:number_plan, :user_created_id, :user_updated_id, :customer_id, :company_id, :method_payment_id ,:sale_quotation_id, :status, :total_amount, :bank_id, :reference)
    end

    def title
      @titulobanner =  I18n.t('.general.models.plans') << " " << I18n.t('.general.connectors.of') << " " << I18n.t('.general.attribute.health')
    end
end
