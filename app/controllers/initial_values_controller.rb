class InitialValuesController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :modificar
  before_action :set_initial_value, only: [:show, :edit, :update, :destroy]

  # GET /initial_values
  # GET /initial_values.json
  def index
    @initial_values = InitialValue.all
  end

  # GET /initial_values/1
  # GET /initial_values/1.json
  def show
  end

  # GET /initial_values/new
  def new
    @initial_value = InitialValue.new
  end

  # GET /initial_values/1/edit
  def edit
  end

  # POST /initial_values
  # POST /initial_values.json
  def create
    @initial_value = InitialValue.new(initial_value_params)
    @initial_value.user_created_id = current_user.id
    respond_to do |format|
      if @initial_value.save
        format.html { redirect_to @initial_value, notice: 'Valores iniciales creados con exitó.' }
        format.json { render :show, status: :created, location: @initial_value }
      else
        format.html { render :new }
        format.json { render json: @initial_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /initial_values/1
  # PATCH/PUT /initial_values/1.json
  def update
    @initial_value.user_updated_id = current_user.id
    respond_to do |format|
      if @initial_value.update(initial_value_params)
        format.html { redirect_to @initial_value, notice: 'Valores iniciales actualizados con exitó.' }
        format.json { render :show, status: :ok, location: @initial_value }
      else
        format.html { render :edit }
        format.json { render json: @initial_value.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /initial_values/1
  # DELETE /initial_values/1.json
  def destroy
    @initial_value.destroy
    respond_to do |format|
      format.html { redirect_to initial_values_url, notice: 'Valores iniciales eliminados con exitó.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_initial_value
      @initial_value = InitialValue.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def initial_value_params
      params.require(:initial_value).permit(
        :days_validity, 
        :max_refech_service, 
        :number_employee, 
        :max_quantity_product,
        :email_max_quantity,
        :days_validity_service,
        :email_security,
        :administration_email,
        :call_center_email
        )
    end
end
