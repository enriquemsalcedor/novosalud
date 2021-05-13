class Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]
after_action  :limpiar_temporales, only: [:update]

  # GET /resource/sign_up
   def new
     $client = params[:cliente] 
     super
   end

  # POST /resource
   def create 
     super
   end

  # GET /resource/edit
   def edit    
    @user = current_user
    super
   end

  # PUT /resource
  def update #Ul+9Am"4
    session[:current_password] = params[:user][:current_password]   
    session[:password]=params[:user][:password]
    session[:password_confirmation]=params[:user][:password_confirmation]
    $controller = params[:controller]
    $password = params[:user][:password]
    if !params[:user][:current_password].present? && !params[:user][:password].present? && !params[:user][:password_confirmation].present?
      flash[:errors_current_password] = "Por favor, introduzca contraseña actual."
      flash[:errors_password] = "Por favor, introduzca nueva contraseña."
      flash[:errors_confirmation] = "Por favor, introduzca confirmación de nueva contraseña."
      render :edit
      limpiar_errores
    elsif params[:user][:current_password].present? && !params[:user][:password_confirmation].present? && !params[:user][:password].present?
      @password_user = HistoryPassword.find_by(password: params[:user][:current_password])
      if @password_user.nil?
        flash[:errors_current_password] = "Contraseña actual es incorrecta."
        flash[:errors_password] = "Por favor, introduzca nueva contraseña."
        flash[:errors_confirmation] = "Por favor, introduzca confirmación de nueva contraseña."
        render :edit
        limpiar_errores
      else  
        flash[:errors_password] = "Por favor, introduzca nueva contraseña."
        flash[:errors_confirmation] = "Por favor, introduzca confirmación de nueva contraseña."
        render :edit
        limpiar_errores
      end
    elsif params[:user][:current_password].present? && params[:user][:password].present? && !params[:user][:password_confirmation].present?
      flash[:errors_confirmation] = "Por favor, introduzca confirmación de nueva contraseña."
      render :edit
      limpiar_errores
    else
      unless @user.similitud_datos_personales?
        if @user.existe_password? 
          $clave = @user.encrypted_password
          if @user.existen_menos_3_password?
            super    
            if @user.registrar_password_menos_3_registros?
              self.cerrar_sesion
            end
            session[:current_password] =nil
            session[:password]=nil
            session[:password_confirmation]= nil
          else
            super
            if @user.registrar_password_mayor_3_registros?
             self.cerrar_sesion
           end   
           session[:current_password] =nil
           session[:password]=nil
           session[:password_confirmation]= nil
         end  
       else
         flash[:errors_password] = "La contraseña que desea registrar ya ha sido utilizada en las últimas 3 actualizaciones."
         render :edit, notice: "La contraseña que desea registrar ya ha sido utilizada en las últimas 3 actualizaciones."
       end  
     else
       flash[:errors_password] = "La contraseña no debe incluir datos personales."
       render :edit, notice: "La contraseña no debe incluir datos personales."
     end  
   end  
 end


  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up,:client_type, keys: [:attribute])
   end

  # If you have extra params to permit, append them to the sanitizer.
   def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update,:password_changed_at,keys: [:attribute])
   end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  def cerrar_sesion
    session[:action] = params[:action]
    session[:action_layout] = session[:layout]
    sign_out current_user
  end  
  def limpiar_temporales
    if @user.verificar_passwords?
      @user.update_attributes(:password_changed_at => Date.today, :temporary_password =>nil, :temporary_password_valid=> nil)
    end  
  end
  
  private

  def limpiar_errores
    flash[:errors_current_password] = nil
    flash[:errors_password] = nil
    flash[:errors_confirmation] = nil 
  end
end
