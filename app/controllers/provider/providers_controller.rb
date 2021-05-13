class Provider::ProvidersController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :set_provider_provider, only: [:show, :edit, :update, :destroy, :habilitar,
  :inhabilitar]
  before_action :title

  # GET /provider/providers
  # GET /provider/providers.json
  def index
    @provider_providers = Provider::Provider.all
    respond_to do |format|
      if params[:search]
        format.html { @provider_providers = Provider::Provider.search(params[:search]).order("created_at DESC")}
        format.json { @provider_providers = Provider::Provider.search(params[:search]).order("created_at DESC")}
      else
        format.html { @provider_providers = Provider::Provider.all.order('created_at DESC')}
        format.json { @provider_providers = Provider::Provider.all.order('created_at DESC')}
      end
    end
  end

  # GET /provider/providers/1
  # GET /provider/providers/1.json
  def show
    @medical_equipment =  Provider::MedicoProvider.where(provider_provider_id: params[:id])    
  end 

  # GET /provider/providers/new
  def new
    @provider_provider = Provider::Provider.new
  end

  # GET /provider/providers/1/edit
  def edit
  end

  # POST /provider/providers
  # POST /provider/providers.json
  def create
    @provider_provider = Provider::Provider.new(provider_provider_params)
    @provider_provider.user_created_id = current_user.id
    respond_to do |format|
      if @provider_provider.save
        format.html { redirect_to provider_providers_path, notice: I18n.t('.providers.controller.create')  }
        format.json { render :show, status: :created, location: @provider_provider }
      else
        format.html { render :new }
        format.json { render json: @provider_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /provider/providers/1
  # PATCH/PUT /provider/providers/1.json
  def update
    @provider_provider.user_updated_id = current_user.id
    respond_to do |format|
      if @provider_provider.update(provider_provider_params)
        format.html { redirect_to provider_providers_path, notice: I18n.t('providers.controller.update')  }
        format.json { render :show, status: :ok, location: @provider_provider }
      else
        format.html { render :edit }
        format.json { render json: @provider_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provider/providers/1
  # DELETE /provider/providers/1.json
  def destroy
    @provider_provider.destroy
    respond_to do |format|
      format.html { redirect_to provider_providers_url, notice: 'Provider was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def habilitar
    if @provider_provider.habilitar!
      @provider_provider.update(:user_updated_id => current_user.id)
      redirect_to provider_providers_path, notice: I18n.t('providers.controller.enable')
    end
  end

  #Eliminar Logico
  def inhabilitar
    if @provider_provider.inhabilitar!
      @provider_provider.update(:user_updated_id => current_user.id)
      redirect_to provider_providers_path, notice: I18n.t('providers.controller.disable')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider_provider
      @provider_provider = Provider::Provider.find(params[:id])
    end

    def provider_provider_params
      params.require(:provider_provider).permit(
        :clinic_code,
        :name,
        :type_identification,
        :rif,
        :phone,
        :phone2,
        :phone3,
        :email,
        :provider_provider_type_id,
        :address,
        :type_identification_responsable,
        :identification_document,
        :firt_name_responsable,
        :last_name_responsable,
        :phone_responsable,
        :position,
        :email_responsable,
        :image
      )
    end
    def title
      @titulobanner =  I18n.t ('.general.models.providers')
    end
end
