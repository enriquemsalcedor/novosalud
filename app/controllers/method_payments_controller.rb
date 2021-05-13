class MethodPaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :set_method_payment, only: [:show, :edit, :update, :destroy, :habilitar, :inhabilitar]
  before_action :title

  # GET /method_payments
  # GET /method_payments.json
    def index
    respond_to do |format|
      if params[:search]
        format.html { @method_payments = MethodPayment.search(params[:search]).order("created_at DESC")}
        format.json { @method_payments = MethodPayment.search(params[:search]).order("created_at DESC")}
      else
        format.html { @method_payments = MethodPayment.all.order('created_at DESC')}
        format.json { @method_payments = MethodPayment.all.order('created_at DESC')}
      end
    end
  end


  # GET /method_payments/1
  # GET /method_payments/1.json
  def show
  end

  # GET /method_payments/new
  def new
    @method_payment = MethodPayment.new
  end

  # GET /method_payments/1/edit
  def edit
  end

  # POST /method_payments
  # POST /method_payments.json
  def create
    @method_payment = MethodPayment.new(method_payment_params)
    @method_payment.user_created_id = current_user.id
    respond_to do |format|
      if @method_payment.save
        format.html { redirect_to method_payments_path, notice:  I18n.t('method_payments.controller.create')}
        format.json { render :show, status: :created, location: @method_payment }
      else
        format.html { render :new }
        format.json { render json: @method_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /method_payments/1
  # PATCH/PUT /method_payments/1.json
  def update
    @method_payment.user_updated_id = current_user.id
    respond_to do |format|
      if @method_payment.update(method_payment_params)
        format.html { redirect_to method_payments_path, notice: I18n.t('method_payments.controller.update')}
        format.json { render :show, status: :ok, location: @method_payment }
      else
        format.html { render :edit }
        format.json { render json: @method_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /method_payments/1
  # DELETE /method_payments/1.json
  def destroy
    @method_payment.destroy
    respond_to do |format|
      format.html { redirect_to method_payments_url, notice: '' }
      format.json { head :no_content }
    end
  end

  def habilitar
    if @method_payment.habilitar!
      @method_payment.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to method_payments_path, notice:  I18n.t('method_payments.controller.enable') }
        format.json { head :no_content }
      end
    end
  end

  #Eliminar Logico
  def inhabilitar
    if @method_payment.inhabilitar!
      @method_payment.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to method_payments_path, notice: I18n.t('method_payments.controller.disable')  }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_method_payment
      @method_payment = MethodPayment.find(params[:id])
    end

    def title
      @titulobanner =  I18n.t ('.general.models.methods_payment')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def method_payment_params
      params.require(:method_payment).permit(
        :name,
        :user_created_id,
        :user_updated_id
      )
    end
end
