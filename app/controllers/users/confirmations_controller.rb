class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    unless params[:user].nil?
      @user = User.find_by(username: params[:user])
      @employee = Employee.find_by(user_id: @user.id)
      @employee.update(:status => 'Activo', :confirmed => true)
    end  
    super
  end

  #protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    unless params[:user].nil?
      admin_path
    else
      new_user_session_path
    end
     #super(resource_name, resource)
   end
 end
