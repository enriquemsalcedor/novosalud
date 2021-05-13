class Security::RolesController < ApplicationController
  before_action :authenticate_user!
  before_action :title
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :activar
  before_action :set_security_role, only: [:show, :edit, :update, :destroy, :habilitar, :inhabilitar]
  # GET /security/roles
  # GET /security/roles.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @security_roles = Security::Role.search(params[:search]).order("created_at DESC")}
        format.json { @security_roles = Security::Role.search(params[:search]).order("created_at DESC")}
      else
        format.html { @security_roles = Security::Role.all.order('created_at DESC')}
        format.json { @security_roles = Security::Role.all.order('created_at DESC')}
      end
    end
  end

  # GET /security/roles/1
  # GET /security/roles/1.json
  def show
    @opciones = Security::Menu.all.order(is_father: :ASC)
    @role_menu = Security::RoleMenu.new
    @role_menu = Security::RoleMenu.where(security_role_id: params[:id])
  end

  # GET /security/roles/new
  def new
    @security_role = Security::Role.new
  end

  # GET /security/roles/1/edit
  def edit
  end

  # POST /security/roles
  # POST /security/roles.json
  def create
    @security_role = Security::Role.new(security_role_params)
    @security_role.user_created_id = current_user.id
    respond_to do |format|
      if @security_role.save
        format.html { redirect_to @security_role, notice: I18n.t('roles.controller.create') }
        format.json { render :show, status: :created, location: @security_role }
      else
        format.html { render :new }
        format.json { render json: @security_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /security/roles/1
  # PATCH/PUT /security/roles/1.json
  def update
    @security_role.update(:user_updated_id => current_user.id)
    respond_to do |format|
      if @security_role.update(security_role_params)
        format.html { redirect_to @security_role, notice: I18n.t('roles.controller.update') }
        format.json { render :show, status: :ok, location: @security_role }
      else
        format.html { render :edit }
        format.json { render json: @security_role.errors, status: :unprocessable_entity }
      end
    end
  end

  def habilitar
    if @security_role.habilitar!
      @security_role.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to @security_role, notice: I18n.t('roles.controller.enable')}
        format.json { head :no_content }
      end
    end
  end

  #Eliminar Logico
  def inhabilitar
    @profile = Security::Profile.find_by(security_role_id: @security_role.id)
    if @profile.nil?
      if @security_role.inhabilitar!
        @security_role.update(:user_updated_id => current_user.id)
        respond_to do |format|
          format.html { redirect_to  @security_role, notice: I18n.t('roles.controller.disable') }
          format.json { head :no_content }
        end
      end
    else
        flash[:alert] = I18n.t('general.action.response.role.asigned_profile')
        redirect_to security_roles_path
    end 
  end

  def redir
    flash[:notice] = "Rol configurado exitosamente"
    redirect_to security_roles_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_security_role
      @security_role = Security::Role.find(params[:id])
    end

    def title
      @titulobanner =  I18n.t ('.general.models.roles')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def security_role_params
      params.require(:security_role).permit(
        :name,
        :user_created_id,
        :user_updated_id
      )
    end
end
