class Provider::ProviderTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :set_provider_provider_type, only: [:show, :edit, :update, :destroy, :habilitar, :inhabilitar]
  before_action :title

  # GET /provider/provider_types
  # GET /provider/provider_types.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @provider_provider_types = Provider::ProviderType.search(params[:search]).order("created_at DESC")}
        format.json { @provider_provider_types = Provider::ProviderType.search(params[:search]).order("created_at DESC")}
      else
        format.html { @provider_provider_types = Provider::ProviderType.all.order('created_at DESC')}
        format.json { @provider_provider_types = Provider::ProviderType.all.order('created_at DESC')}
      end
    end
  end

  # GET /provider/provider_types/1
  # GET /provider/provider_types/1.json

  def show
  end

  # GET /provider/provider_types/new
  def new
    @provider_provider_type = Provider::ProviderType.new
  end

  # GET /provider/provider_types/1/edit
  def edit
  end

  # POST /provider/provider_types
  # POST /provider/provider_types.json
  def create
    @provider_provider_type = Provider::ProviderType.new(provider_provider_type_params)
    @provider_provider_type.user_created_id = current_user.id
    respond_to do |format|
      if @provider_provider_type.save
        format.html { redirect_to provider_provider_types_path, notice: I18n.t('provider_types.controller.create')  }
        format.json { render :show, status: :created, location: @provider_provider_type }
      else
        format.html { render :new }
        format.json { render json: @provider_provider_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /provider/provider_types/1
  # PATCH/PUT /provider/provider_types/1.json
  def update
    @provider_provider_type.user_updated_id = current_user.id
    respond_to do |format|
      if @provider_provider_type.update(provider_provider_type_params)
        format.html { redirect_to provider_provider_types_path, notice: I18n.t('provider_types.controller.update')}
        format.json { render :show, status: :ok, location: @provider_provider_type }
      else
        format.html { render :edit }
        format.json { render json: @provider_provider_type.errors, status: :unprocessable_entity }
      end
    end
  end


  def habilitar
    if @provider_provider_type.habilitar!
      @provider_provider_type.update(:user_updated_id => current_user.id)
      redirect_to provider_provider_types_path, notice: I18n.t('provider_types.controller.enable')
    end
  end

  #Eliminar Logico
  def inhabilitar
    if @provider_provider_type.inhabilitar!
      @provider_provider_type.update(:user_updated_id => current_user.id)
      redirect_to provider_provider_types_path, notice: I18n.t('provider_types.controller.disable')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider_provider_type
      @provider_provider_type = Provider::ProviderType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def provider_provider_type_params
      params.require(:provider_provider_type).permit(:name)
    end

    def title
      @titulobanner =  I18n.t ('.general.models.providers_types')
    end
end
