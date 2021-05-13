class Users::PasswordsController < Devise::PasswordsController
  after_action :cerrar_sesion, only: [:update]
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    @user = User.find_by(email:params[:user][:login])
    unless params[:user][:login].empty?
      unless @user.nil?
        if session[:layout] == "admin"
          if @user.client_type == 'empleado'
            if @user.reset_password_token.nil?
              ResendPasswordMailer.resend_password(@user).deliver_now
              @user.update(:reset_password_token => params[:authenticity_token], :reset_password_sent_at=> Date.today)

              redirect_to admin_path, notice: "La solicitud ha sido enviada"
            else
              flash[:errors] = "Ya #{@user.email} ha enviado una solicitud de recuperación de contraseña."
              redirect_to new_user_password_path
            end  
          else
            flash[:errors] = "Su correo no ha sido registrado como empleado."
            redirect_to new_user_password_path 
          end
        elsif session[:layout] == "application"
          if @user.client_type == 'persona' || @user.client_type == 'empresa'
            super
          else
            flash[:errors] = "Su correo no ha sido registrado como cliente."
            redirect_to new_user_password_path            
          end
        end  
      else
        flash[:errors] = "El correo electrónico #{params[:user][:login]} no esta registrado."
        redirect_to new_user_password_path        
      end
    else
        flash[:errors] = "Debe ingresar un correo electrónico."
        redirect_to new_user_password_path     
    end  
  end

  def edit
    $usuario = params[:user]
    super
  end

  # PUT /resource/password
  def update
    $password = params[:user][:password]
    @user = User.find_by(email: $usuario)
    unless @user.similitud_datos_personales? 
      super
    else
      flash[:errors] = "La contraseña no debe incluir datos personales."
      render :edit
    end  
   end

  # protected

   def after_resetting_password_path_for(resource)
     super(resource)
   end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
   super(resource_name)
  end

  def cerrar_sesion
    sign_out current_user
    session[:action_layout] = session[:layout]
    session[:action] = params[:action]
  end
end
