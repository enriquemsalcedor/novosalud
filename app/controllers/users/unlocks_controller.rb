class Users::UnlocksController < Devise::UnlocksController
  # GET /resource/unlock/new
  # def new
  #   super
  # end

  # POST /resource/unlock
   def create
    @user = User.find_by(email:params[:user][:email])
    unless params[:user][:email].empty?
      unless @user.nil?
        if @user.client_type == 'empleado' &&  !@user.unlock_token.nil?
          UnlockUserMailer.unlock_email(@user).deliver_now
          redirect_to admin_path, notice: "La solicitud ha sido enviada"
        elsif @user.client_type == 'empleado' &&  !@user.unlock_token.nil?
          flash[:errors] = "El correo electrónico #{params[:user][:email]} no esta registrado."
          redirect_to new_user_unlock_path, notice: "Debe ingresar un correo electrónico."
        else  
          super
        end
      else
        flash[:errors] = "Cuenta no se encuentra bloqueada."
        redirect_to new_user_unlock_path, notice: "Debe ingresar un correo electrónico."
      end   
    else
      flash[:errors] = "Debe ingresar un correo electrónico."
      redirect_to new_user_unlock_path     
    end    
   end

  # GET /resource/unlock?unlock_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after sending unlock password instructions
  # def after_sending_unlock_instructions_path_for(resource)
  #   super(resource)
  # end

  # The path used after unlocking the resource
  # def after_unlock_path_for(resource)
  #   super(resource)
  # end
end
