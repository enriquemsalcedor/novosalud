class Security::RoleMenusController < ApplicationController
  before_action :authenticate_user!
  before_action :set_security_role_menu, only: [:show, :edit, :update, :destroy]
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :activar
  # GET /security/role_menus
  # GET /security/role_menus.json
  def index
    @security_role_menus = Security::RoleMenu.all
  end

  # GET /security/role_menus/1
  # GET /security/role_menus/1.json
  def show
    @security_role_type_menu = Security::RoleTypeMenu.new
  end

  # GET /security/role_menus/new
  def new
    @security_role_menu = Security::RoleMenu.new
  end

  # GET /security/role_menus/1/edit
  def edit
    @security_role_type_menu = Security::RoleTypeMenu.where('security_role_menu_id = ?', params[:id])
  end

  # POST /security/role_menus
  # POST /security/role_menus.json
  def create
    @role_menu = Security::RoleMenu.new
    @role_menu.security_role_id = params[:id_role]
    @role_menu.security_menu_id = params[:id_menu]
     respond_to do |format|
      if @role_menu.save
        format.html { redirect_to @role_menu, notice: 'Menú creado exitosamente para este rol.' }
        format.json { render :show, status: :created, location: @role_menu }
        format.js   {} 
      else
        format.html { render :new }
        format.json { render json: @role_menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /security/role_menus/1
  # PATCH/PUT /security/role_menus/1.json
  def update
    respond_to do |format|
      if @security_role_menu.update(security_role_menu_params)
        format.html { redirect_to @security_role_menu, notice: 'Menú actualizado exitosamente para este rol.' }
        format.json { render :show, status: :ok, location: @security_role_menu }
      else
        format.html { render :edit }
        format.json { render json: @security_role_menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /security/role_menus/1
  # DELETE /security/role_menus/1.json
  def destroy
    @security_role = Security::Role.find_by(id: @security_role_menu.security_role.id)
    @security_role.update(:user_updated_id => current_user.id)
    @security_role_menu.destroy
    respond_to do |format|
      format.html { redirect_to security_role_menus_url, notice: 'Menú eliminado exitosamente para este rol.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_security_role_menu
      @security_role_menu = Security::RoleMenu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def security_role_menu_params
      params.require(:security_role_menu).permit(:security_role_id, :security_menu_id)
    end
end
