class Payment::TransferencesController < ApplicationController
  before_action :set_payment_transference, only: [:show, :edit, :update, :destroy]

  # GET /payment/transferences
  # GET /payment/transferences.json
  def index
    @payment_transferences = Payment::Transference.all
  end

  # GET /payment/transferences/1
  # GET /payment/transferences/1.json
  def show
  end

  # GET /payment/transferences/new
  def new
    @payment_transference = Payment::Transference.new
  end

  # GET /payment/transferences/1/edit
  def edit
  end

  # POST /payment/transferences
  # POST /payment/transferences.json
  def create
    session[:reference] = params[:payment_transference][:reference]     
    session[:bank_id] = params[:payment_transference][:bank_id]
#    unless params[:payment_transference][:file].nil?
      @payment_transference = Payment::Transference.new(payment_transference_params)
      respond_to do |format|
        if @payment_transference.save
          format.html { redirect_to '/' , notice: 'Los datos de su transferencia se han registrado satisfactoriamente.' }
          format.json { render :show, status: :created, location: '/'  }
        else
          format.html { redirect_to  payment_transferences_path  }
          format.json { render json: @payment_transference.errors, status: :unprocessable_entity }
        end
      end
      session[:reference] = nil
      session[:bank_id]= nil
#    else
#      flash[:errors_file] ="Debe adjuntar un comprobante de pago."
#      redirect_to "/#{$sale_quotation_id}/transference"      
#    end
  end

  # PATCH/PUT /payment/transferences/1
  # PATCH/PUT /payment/transferences/1.json
  def update
    respond_to do |format|
      if @payment_transference.update(payment_transference_params)
        format.html { redirect_to @payment_transference, notice: 'Transference was successfully updated.' }
        format.json { render :show, status: :ok, location: @payment_transference }
      else
        format.html { render :edit }
        format.json { render json: @payment_transference.errors, status: :unprocessable_entity }
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment_transference
      @payment_transference = Payment::Transference.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payment_transference_params
      params.require(:payment_transference).permit(:bank_id, :sale_quotation_id, :reference, :file)
    end
end
