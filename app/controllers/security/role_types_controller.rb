class Security::RoleTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :title
  before_action :set_security_role_type, only: [:show, :edit, :update, :destroy, :habilitar, :inhabilitar]
  # GET /security/role_types
  # GET /security/role_types.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @security_role_types = Security::RoleType.search(params[:search]).order("created_at DESC")}
        format.json { @security_role_types = Security::RoleType.search(params[:search]).order("created_at DESC")}
      else
        format.html { @security_role_types = Security::RoleType.all.order('created_at DESC')}
        format.json { @security_role_types = Security::RoleType.all.order('created_at DESC')}
      end
    end
  end

  # GET /security/role_types/1
  # GET /security/role_types/1.json
  def show
  end

  # GET /security/role_types/new
  def new
    @security_role_type = Security::RoleType.new
  end

  # GET /security/role_types/1/edit
  def edit
  end

  # POST /security/role_types
  # POST /security/role_types.json
  def create
    @security_role_type = Security::RoleType.new(security_role_type_params)
    @security_role_type.user_created_id = current_user.id
    respond_to do |format|
      if @security_role_type.save
        format.html { redirect_to @security_role_type, notice: I18n.t('role_types.controller.create')}
        format.json { render :show, status: :created, location: @security_role_type }
      else
        format.html { render :new }
        format.json { render json: @security_role_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /security/role_types/1
  # PATCH/PUT /security/role_types/1.json
  def update
    @security_role_type.user_updated_id = current_user.id
    respond_to do |format|
      if @security_role_type.update(security_role_type_params)
        format.html { redirect_to @security_role_type, notice: I18n.t('role_types.controller.update') }
        format.json { render :show, status: :ok, location: @security_role_type }
      else
        format.html { render :edit }
        format.json { render json: @security_role_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def habilitar
    if @security_role_type.habilitar!
      @security_role_type.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to @security_role_type, notice: I18n.t('role_types.controller.enable')}
        format.json { head :no_content }
      end
    end
  end

  #Eliminar Logico
  def inhabilitar
    if @security_role_type.inhabilitar!
      @security_role_type.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to @security_role_type, notice: I18n.t('role_types.controller.disable')}
        format.json { head :no_content }
      end
    end
  end
  
  def title
      @titulobanner =  I18n.t ('.general.models.roles_types')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_security_role_type
      @security_role_type = Security::RoleType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def security_role_type_params
      params.require(:security_role_type).permit(
        :name,
        :user_created_id,
        :user_updated_id
      )
    end
end
