class ApplicationController < ActionController::Base
  # reset captcha code after each request for security

  #configuracion gema auto-session-timeout
  protect_from_forgery with: :exception
  auto_session_timeout 24.hours 
  #fin

  layout :layout_para_admin
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  def configure_permitted_parameters
    update_attrs = [:username, :email, :password, :password_confirmation, :current_password,:remember_me, :client_type, :password_changed_at]  
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
    devise_parameter_sanitizer.permit :sign_up, keys:update_attrs 
  end
  
  def layout_para_admin
    unless current_user.nil?
      @employee = Employee.find_by user_id: current_user.id
      if @employee.nil?
        session[:layout] = 'application'
      else
        session[:layout] = 'admin'
      end
    end
    session[:layout]
  end
  
  def after_sign_out_path_for(resource_or_scope)
    if params[:layout] == 'admin'
      admin_path
    else
      if $client == "persona"
        new_user_session_path(:cliente => "persona")
      elsif $client == "empresa"
        new_user_session_path(:cliente => "empresa")
      else  
        root_path
      end
    end
  end

  #El metodo verificar_permiso recibe el controlador en el que esta situado el usuario y lo compara con los controladores
  #a los que tiene acceso que se encuentran en base de datos y consecutivamente permite el acceso o no a las vistas de este
  #controlador
  def verificar_permiso
    if user_signed_in?
      unless current_user.employee.nil?
        @existe_permiso = false
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu|
          if security_role_menu.security_menu.controller == params[:controller] 
            @existe_permiso = true
            break
          elsif params[:controller] == "service/services" and session[:atender] == true
            @existe_permiso = true
          end
          if params[:controller] == "security/role_type_menus" || params[:controller] == "security/role_menus"
            @existe_permiso = true
          end
        end
        if current_user.username == "aadmin"
          @existe_permiso = true
        end
        if @existe_permiso == false
          redirect_to root_path
        end
      end
    end
  end

  #El metodo crear: Verifica que dentro de la permisologia que tiene el role del usuario logueado se encuentre este permiso
  #si este lo encuentra permite tanto el acceso a la vistas /new de cada controlador asi como la visualizacion del boton
  #"registrar" de cada vista /index
  def crear
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_crear = false
        @security_role_type = Security::RoleType.find_by(name: "Crear").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|    
              if @security_role_type == role_type.security_role_type.name
                @permiso_crear = true
                break
              end
            end
          elsif params[:controller] == "security/role_type_menus"
            params[:controller] = "security/roles"
            if security_role_menu.security_menu.controller == params[:controller] 
              security_role_menu.security_role_type_menus.each do |role_type|
                if @security_role_type == role_type.security_role_type.name
                  @permiso_crear = true
                  break
                end
              end
            end
          end
        end
        if current_user.username == "aadmin"
          @permiso_crear = true
        end
        if params[:action] == "new" && @permiso_crear == false
          redirect_to root_path
        end
        return @permiso_crear
      end
    end
  end

  #El metodo modificar: Verifica que dentro de la permisologia que tiene el role del usuario logueado se encuentre este permiso
  #si este lo encuentra permite tanto el acceso a la vistas /edit de cada controlador asi como la visualizacion del boton
  #"modificar" de cada vista /index y cada vista /show
  def modificar
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_modificar = false
        @security_role_type = Security::RoleType.find_by(name: "Modificar").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|
              if @security_role_type == role_type.security_role_type.name
                @permiso_modificar = true
                break
              end
            end
          elsif params[:controller] == "security/role_type_menus"
            params[:controller] = "security/roles"
            if security_role_menu.security_menu.controller == params[:controller] 
              security_role_menu.security_role_type_menus.each do |role_type|
                if @security_role_type == role_type.security_role_type.name
                  @permiso_modificar = true
                  break
                end
              end
            end
          end
          if params[:controller] == "service/services" && current_user.employee.provider_provider_id.nil?
            @permiso_modificar = true
          end
        end
        if current_user.username == "aadmin" 
          @permiso_modificar = true
        end

        if params[:action] == "edit" && @permiso_modificar == false
          redirect_to root_path
        end
        return @permiso_modificar
      end
    end
  end

  #El metodo consultar: Verifica que dentro de la permisologia que tiene el role del usuario logueado se encuentre este permiso
  #si este lo encuentra permite tanto el acceso a la vistas /show de cada controlador asi como la visualizacion del boton
  #"ver" de cada vista /index y cada vista /edit
  def consultar
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_consultar = false
        @security_role_type = Security::RoleType.find_by(name: "Consultar").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|
              if @security_role_type == role_type.security_role_type.name || role_type.security_role_type.name == "Pagar"
                @permiso_consultar = true
                break
              end
            end
          end
        end
        if current_user.username == "aadmin"
          @permiso_consultar = true
        end
        if params[:action] == "show" && @permiso_consultar == false
          redirect_to root_path
        end
        return @permiso_consultar
      end
    end
  end

  #El metodo eliminar: Verifica que dentro de la permisologia que tiene el role del usuario logueado se encuentre este permiso
  #si este lo encuentra permite eliminar datos. Cabe mencionar que este metodo es mayormente usado en las tablas intermedias debido
  #a que solo en esas instancias esta permitido eliminado fisico.
  def eliminar
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_eliminar = false
        @security_role_type = Security::RoleType.find_by(name: "Eliminar").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|
              if @security_role_type == role_type.security_role_type.name
                @permiso_eliminar = true
                break
              end
            end
          elsif params[:controller] == "security/role_type_menus"
            params[:controller] = "security/roles"
            if security_role_menu.security_menu.controller == params[:controller] 
              security_role_menu.security_role_type_menus.each do |role_type|
                if @security_role_type == role_type.security_role_type.name
                  @permiso_eliminar = true
                  break
                end
              end
            end
          end
        end
        if current_user.username == "aadmin"
          @permiso_eliminar = true
        end
        if params[:action] == "delete" && @permiso_eliminar == false
          redirect_to root_path
        end
        return @permiso_eliminar
      end
    end
  end

  #El metodo activar: Verifica que dentro de la permisologia que tiene el role del usuario logueado se encuentre este permiso
  #si este lo encuentra permite realizar la activacion o desactivacion de productos, paquetes, especialidades, bancos, etc.
  def activar
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_activar = false
        @security_role_type = Security::RoleType.find_by(name: "Activar").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|
              if @security_role_type == role_type.security_role_type.name
                @permiso_activar = true
                break
              end
            end
          end
        end
        if current_user.username == "aadmin"
          @permiso_activar = true
        end
        return @permiso_activar
      end
    end
  end

  #El metodo anular: Verifica que dentro de la permisologia que tiene el role del usuario logueado se encuentre este permiso
  #si este lo encuentra permite realizar anulacion de servicos en el controlador service/service
  def permiso_anular
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_anular = false
        @security_role_type = Security::RoleType.find_by(name: "Anular").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|
              if @security_role_type == role_type.security_role_type.name
                @permiso_anular = true
                break
              end
            end
          end
        end
        if current_user.username == "aadmin"
          @permiso_anular = true
        end
        if params[:action] == "anular" && @permiso_anular == false
          redirect_to root_path
        end
        return @permiso_anular
      end
    end
  end

  #El metodo anular: Verifica que dentro de la permisologia que tiene el role del usuario logueado se encuentre este permiso
  #si este lo encuentra permite realizar reagendado de servicos en el controlador service/service
  def permiso_reagendar
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_reagendar = false
        @security_role_type = Security::RoleType.find_by(name: "Reagendar").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|
              if @security_role_type == role_type.security_role_type.name
                @permiso_reagendar = true
                break
              end
            end
          end
        end
        if current_user.username == "aadmin"
          @permiso_reagendar = true
        end
        if params[:action] == "reagendar" && @permiso_reagendar == false
          redirect_to root_path
        end
        return @permiso_reagendar
      end
    end
  end


  #El metodo cancelar: Verifica que dentro de la permisologia que tiene el role del usuario logueado se encuentre este permiso
  #si este lo encuentra permite realizar cancelaciones de servicos en el controlador service/service
  def permiso_cancelar
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_cancelar = false
        @security_role_type = Security::RoleType.find_by(name: "Cancelar").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|
              if @security_role_type == role_type.security_role_type.name
                @permiso_cancelar = true
                break
              end
            end
          end
        end
        if current_user.username == "aadmin"
          @permiso_cancelar = true
        end
        if params[:action] == "cancelar" && @permiso_cancelar == false
          redirect_to root_path
        end
        return @permiso_cancelar
      end
    end
  end

  #El metodo atender: Verifica que dentro de la permisologia que tiene el role del usuario logueado se encuentre este permiso
  #si este lo encuentra permite realizar el cambio de estatus del servicio a "Atendido"
  def permiso_atender
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_atender = false
        @security_role_type = Security::RoleType.find_by(name: "Atender").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|
              if @security_role_type == role_type.security_role_type.name
                @permiso_atender = true
                break
              end
            end
          end
        end
        if current_user.username == "aadmin"
          @permiso_atender = true
        end
        if params[:action] == "atender" && @permiso_atender == false
          redirect_to root_path
        end
        return @permiso_atender
      end
    end
  end

  def permiso_pagar
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_pagar = false
        @security_role_type = Security::RoleType.find_by(name: "Pagar").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|
              if @security_role_type == role_type.security_role_type.name
                @permiso_pagar = true
                break
              end
            end
          end
        end
        if current_user.username == "aadmin"
          @permiso_pagar = true
        end
        if params[:action] == "pagar" && @permiso_pagar == false
          redirect_to root_path
        end
        return @permiso_pagar
      end
    end
  end

  #El metodo desbloquear: Verifica que dentro de la permisologia que tiene el role del usuario logueado se encuentre este permiso
  #si este lo encuentra permite realizar el desbloqueo de usuarios 
  def desbloquear
    @bandera = false
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_desbloquear = false
        @security_role_type = Security::RoleType.find_by(name: "Desbloquear Usuario").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|
              if @security_role_type == role_type.security_role_type.name
                @permiso_desbloquear = true
                break
              elsif role_type.security_role_type.name == "Consultar"
                @bandera = true
              end
            end
          end
        end
        if current_user.username == "aadmin"
          @permiso_desbloquear = true
        end

        if @bandera == true
        elsif params[:action] == "blocked_user" && @permiso_desbloquear == false
          redirect_to root_path
        end
        return @permiso_desbloquear
      end
    end
  end

    #El metodo reenviar_usuario: Verifica que dentro de la permisologia que tiene el role del usuario logueado se encuentre este permiso
  #si este lo encuentra permite realizar el desbloqueo de usuarios 
  def reenviar_usuario
    @bandera = false
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_reenviar_usuario = false
        @security_role_type = Security::RoleType.find_by(name: "Reenviar Usuario").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|
              if @security_role_type == role_type.security_role_type.name
                @permiso_reenviar_usuario = true
                break
              elsif role_type.security_role_type.name == "Consultar"
                @bandera = true
              end
            end
          end
        end
        if current_user.username == "aadmin"
          @permiso_reenviar_usuario = true
        end
        if @bandera == true
        elsif params[:action] == "forget_username_list" && @permiso_reenviar_usuario == false
          redirect_to root_path
        end
        return @permiso_reenviar_usuario
      end
    end
  end

    #El metodo reenviar_contraseña: Verifica que dentro de la permisologia que tiene el role del usuario logueado se encuentre este permiso
  #si este lo encuentra permite realizar el desbloqueo de usuarios 
  def reenviar_contraseña
    @bandera = false
    if user_signed_in?
      unless current_user.employee.nil?
        @permiso_reenviar_contraseña = false
        @security_role_type = Security::RoleType.find_by(name: "Reenviar Contraseña").name
        current_user.employee.security_profile.security_role.security_role_menus.each do  |security_role_menu| 
          if security_role_menu.security_menu.controller == params[:controller] 
            security_role_menu.security_role_type_menus.each do |role_type|
              if @security_role_type == role_type.security_role_type.name
                @permiso_reenviar_contraseña = true
                break
              elsif role_type.security_role_type.name == "Consultar"
                @bandera = true
              end
            end
          end
        end
        if current_user.username == "aadmin"
          @permiso_reenviar_contraseña = true
        end
        if @bandera == true
        elsif params[:action] == "forget_password" && @permiso_reenviar_contraseña == false
          redirect_to root_path
        end
        return @permiso_reenviar_contraseña
      end
    end
  end
end
