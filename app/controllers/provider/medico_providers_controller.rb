class Provider::MedicoProvidersController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :set_provider_medico_provider, only: [:show, :edit, :update, :destroy]
  
  # GET /provider/medico_providers
  # GET /provider/medico_providers.json
  def index
    @provider_medico_providers = Provider::MedicoProvider.all
  end

  # GET /provider/medico_providers/1
  # GET /provider/medico_providers/1.json
  def show
  end 
  
  # GET /provider/medico_providers/new
  def new

  end

  # GET /provider/medico_providers/1/edit
  def edit
  end


  # POST /provider/medico_providers
  # POST /provider/medico_providers.json
  def create
    @medico_provider = Provider::MedicoProvider.new(provider_medico_provider_params)
    unless $medicoProvider.nil?
      @medicoProvider = $medicoProvider
    else
      @medicoProvider = Provider::Medico.last
    end
    
    unless @medicoProvider.nil?
      @medico_provider.provider_medico_id = @medicoProvider.id
    end

    @medico_provider.user_created_id = current_user.id
    respond_to do |format|
      if @medico_provider.save
        format.html { redirect_to @medico_provider, notice: 'Se creó con exitó el proveedor para este medico.' }
        format.json { render :show, status: :created, location: @medico_provider }
        format.js   { render 'provider/medico_providers/create.js.erb' }
      else
        format.html { render :new }
        format.json { render json: @medico_provider.errors, status: :unprocessable_entity }
        format.js { render json: @medico_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /provider/medico_providers/1
  # PATCH/PUT /provider/medico_providers/1.json
  def update
    @provider_medico_provider.user_updated_id = current_user.id
    respond_to do |format|
      if @provider_medico_provider.update(provider_medico_provider_params)
        format.html { redirect_to @provider_medico_provider, notice: 'Se actualizó con exitó el proveedor para este medico.' }
        format.json { render :show, status: :ok, location: @provider_medico_provider }
      else
        format.html { render :edit }
        format.json { render json: @provider_medico_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provider/medico_providers/1
  # DELETE /provider/medico_providers/1.json
  def destroy
    @idMEdico_Provider= @provider_medico_provider.provider_medico_id
    @provider_medico_provider.destroy
    respond_to do |format|
      format.html { redirect_to provider_medico_providers_url, notice: 'Se eliminó con exitó el proveedor para este medico.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider_medico_provider
      @provider_medico_provider = Provider::MedicoProvider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def provider_medico_provider_params
      params.require(:provider_medico_provider).permit(:provider_provider_id, :provider_medico_id)
    end
end
