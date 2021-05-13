class Security::RoleTypeMenusController < ApplicationController
  before_action :authenticate_user!  
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :set_security_role_type_menu, only: [:show, :edit, :update, :destroy]

  # GET /security/role_type_menus
  # GET /security/role_type_menus.json
  def index
    @security_role_type_menus = Security::RoleTypeMenu.all
  end

  # GET /security/role_type_menus/1
  # GET /security/role_type_menus/1.json
  def show
  end

  # GET /security/role_type_menus/new
  def new
    @security_role_type_menu = Security::RoleTypeMenu.new
    @security_role_menu = Security::RoleMenu.new
    @security_menu = Security::Menu.find(params[:id_menu])
    @security_role_type_menu_usuario = Security::RoleMenu.where('security_menu_id = ? and security_role_id = ?', params[:id_menu], params[:id_role])
    @security_role_type = Security::RoleType.new
    unless @security_role_type_menu_usuario.empty?
      unless @security_role_type_menu_usuario[0].security_role_type_menus.empty?
        @aux = []
        #Arreglo auxiliar para obtener los type menu que ya posee el cliente y realizar la busqueda a partir de estos
        @security_role_type_menu_usuario[0].security_role_type_menus.each do |type| 
          @aux << type.security_role_type.name
        end

        puts "imprimiendo 1"
        if @security_role_type_menu_usuario[0].security_menu.action?
          puts "imprimiendo 2"
          @security_role_type = Security::RoleType.where('name not in (?) and action = true and controller = ? ',@aux , @security_role_type_menu_usuario[0].security_menu.controller)
          if @security_role_type_menu_usuario[0].security_menu.controller == "sale/quotations"
            @security_role_type = Security::RoleType.perm(@security_role_type_menu_usuario[0].security_menu,@aux)
          end
        else
          puts "imprimiendo 3"
          #@security_role_type = Security::RoleType.where('name not in (?) and action = false and controller is null ',@aux )
          @security_role_type = Security::RoleType.perm(@security_role_type_menu_usuario[0].security_menu,@aux)
        end
      else
        @aux = []
        puts "imprimiendo 4"
        if @security_role_type_menu_usuario[0].security_menu.action?
          puts "imprimiendo 5"
          #@security_role_type = Security::RoleType.where('action = true and controller = ? ',@security_role_type_menu_usuario[0].security_menu.controller)
          @security_role_type = Security::RoleType.perm(@security_role_type_menu_usuario[0].security_menu,@aux)
        else
          puts "imprimiendo 6"
          #@security_role_type = Security::RoleType.where('action = false and controller is null ')
          @security_role_type = Security::RoleType.perm(@security_menu,@aux)
        end
      end
    else
      @aux = []
      puts "imprimiendo 7"
      if @security_menu.action?
        puts "imprimiendo 8"
        #@security_role_type = Security::RoleType.where('action = true and controller = ?', @security_menu.controller)
        @security_role_type = Security::RoleType.perm(@security_menu,@aux)
      else
        puts "imprimiendo 9"
        #@security_role_type = Security::RoleType.where('action = false and controller is null ')
        @security_role_type = Security::RoleType.perm(@security_menu,@aux)
      end
    end

    @security_role_type_menu.id_role = params[:id_role]
    @security_role_type_menu.id_menu = params[:id_menu]
  end

  # GET /security/role_type_menus/1/edit
  def edit
  end

  # POST /security/role_type_menus
  # POST /security/role_type_menus.json
  def create
    @security_role_type_menu = Security::RoleTypeMenu.new(security_role_type_menu_params)
    unless params[:security_role_type_ids].nil? 
      @security_role = Security::Role.find_by(id: @security_role_type_menu.id_role)
      @security_role.update(:user_updated_id => current_user.id)
      @role_menu = Security::RoleMenu.find_by(:security_role_id => @security_role_type_menu.id_role, :security_menu_id => @security_role_type_menu.id_menu)
      if @role_menu.nil?

        @role_menu = Security::RoleMenu.create(
          :security_role_id => @security_role_type_menu.id_role,
          :security_menu_id => @security_role_type_menu.id_menu
          )
      end
        params[:security_role_type_ids].each do |role_types|
          Security::RoleTypeMenu.create(
            security_role_menu_id: @role_menu.id,
            security_role_type_id: role_types )
        end
        respond_to do |format|
          format.js { render 'security/role_menus/create.js.erb'}
        end
    end
  end

  # PATCH/PUT /security/role_type_menus/1
  # PATCH/PUT /security/role_type_menus/1.json
  def update
    respond_to do |format|
      if @security_role_type_menu.update(security_role_type_menu_params)
        format.html { redirect_to @security_role_type_menu, notice: 'Permiso actualizado correctamente.' }
        format.json { render :show, status: :ok, location: @security_role_type_menu }
      else
        format.html { render :edit }
        format.json { render json: @security_role_type_menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /security/role_type_menus/1
  # DELETE /security/role_type_menus/1.json
  def destroy
    @role_type = @security_role_type_menu.security_role_type
    @security_role_type_menu.destroy
    @security_role = Security::Role.find_by(id: @security_role_type_menu.security_role_menu.security_role.id)
    @security_role.update(:user_updated_id => current_user.id)
    respond_to do |format|
      format.html { redirect_to security_role_type_menus_url, notice: 'Permiso eliminado correctamente.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_security_role_type_menu
      @security_role_type_menu = Security::RoleTypeMenu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def security_role_type_menu_params
      params.require(:security_role_type_menu).permit(:security_role_type_id, :security_role_menu_id, :id_menu, :id_role)
    end
end
