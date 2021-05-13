class EmployeesController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :show, :edit, :update, :habilitar,
    :inhabilitar, :update_user, :eliminar, :unblocked, :blocked_user, :forget_password,
    :resend_username,:resend_password, :motive, :redireccionamiento_eliminar, :eliminar_logico, :show_list]
  before_action :verificar_permiso
  before_action :crear 
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :desbloquear
  before_action :reenviar_usuario
  before_action :reenviar_contraseña
  before_action :verificar_tipo_empleado
  before_action :title
  before_action :set_employee, only: [:show, :edit, :update, :habilitar,
    :inhabilitar, :update_user, :eliminar, :unblocked, :resend_username,
    :resend_password, :motive, :redireccionamiento_eliminar, :eliminar_logico, :show_list]

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.all
    if $empleado == "externo"
      @employees = Employee.where.not(provider_provider_id: nil, status: 'Eliminado').order(updated_at: :desc)
    elsif $empleado == "interno"
      @employees = Employee.where('"employees"."security_profiles_id" is not null and "employees"."provider_provider_id" is null and "employees"."status" != ? and "employees"."code_employee" != ?', "Eliminado", "1").order(updated_at: :desc)
    end
    respond_to do |format|
      if params[:search]
        format.html { @employees = @employees.search(params[:search]).order("created_at DESC")}
        format.json { @employees = @employees.search(params[:search]).order("created_at DESC")}
      else
        format.html { @employees = @employees.order('created_at DESC')}
        format.json { @employees = @employees.order('created_at DESC')}
      end
    end
  end

  def show_list
  end  

  # GET /employees/1
  # GET /employees/1.json
  def show 
    @motives_history = MotiveEmployee.where(employee_id: params[:id]).order("created_at DESC")  
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
    @empleado_confirmado = Employee.find_by(id: params[:id])
    if @empleado_confirmado.confirmed?
      @employee.usuario = @employee.user.username    
    else
      flash[:notice] = "El empleado #{@empleado_confirmado.usuario}, no está confirmado."
      redirect_to employees_path
    end  
  end

  def motive
    puts "#{$empleado}"
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)
    @employee.user_created_id = current_user.id
    @employee.usuario_externo
    @employee.usuario = params[:employee][:usuario]
    @employee.previous_profile_security = params[:employee][:security_profiles_id]
    respond_to do |format|
      if @employee.save
        format.html { redirect_to employees_path, notice: I18n.t('.employees.controller.create') }
        format.json { render :show, status: :created, location: @employee }
      else
        format.html { render :new }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    $usuario = params[:employee][:usuario]
    @employee.user_updated_id = current_user.id
    @employee.usuario = params[:employee][:usuario]
    if @employee.update(employee_params)
      if params[:employee][:type_profile] == 'Temporal'
        @employee.vencer_perfil
      end  
      actualizar_previous_profile_security
      @employee.usuario = params[:employee][:usuario]
      $username = params[:employee][:usuario]
      if@employee.validate_username?
        actualizar_usuario
        if @employee.update_email?
          respond_to do |format|
            format.html { redirect_to employees_path,notice: I18n.t('employees.controller.update_email') }
            format.json { render :show, status: :ok, location: @employee }   
          end     
        else   
          respond_to do |format|
            format.json { render :show, status: :ok, location: @employee }
            if $empleado == "interno"
              format.html { redirect_to employees_path, notice: I18n.t('employees.controller.update') }
            else
              format.html { redirect_to employees_path, notice: I18n.t('employees.controller.update_clinic') }
            end
          end  
        end
        $usuario=nil
      else
        actualizar_usuario
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: @employee.errors, status: :unprocessable_entity }
        end 
      end
     else
      actualizar_usuario
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end

  end

  def profile
    @employee = Employee.find(current_user.employee)    
  end

  def update_user
    @user = User.find_by(id: @employee.user_id)
    @employee.usuario = params[:usuario]
    if @employee.validate_username?
      @user.update_attributes(:username => params[:usuario])
      respond_to do |format|
        format.html { redirect_to @employee, notice: I18n.t('employees.controller.update_user') }
      end
    else
      flash[:errors] = "El usuario #{@employee.usuario}, ya existe."
      redirect_to @employee
    end
  end

  def blocked_user
    @employees= Employee.joins(:user).where('"users"."unlock_token" is not null and "users"."client_type" = ?', "empleado")
    respond_to do |format|
      if params[:search]
        format.html { @employees = @employees.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 9) }
        format.json { @employees = @employees.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 9) }
      else
        format.html { @employees = @employees.order('created_at DESC').paginate(:page => params[:page], :per_page => 9) }
        format.json { @employees = @employees.order('created_at DESC').paginate(:page => params[:page], :per_page => 9) }
      end
    end 
  end
  
  def forget_password
    @employees= Employee.joins(:user).where('"users"."reset_password_token" is not null and "users"."client_type" = ?', "empleado")
    respond_to do |format|
      if params[:search]
        format.html { @employees = @employees.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 9) }
        format.json { @employees = @employees.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 9) }
      else
        format.html { @employees = @employees.order('created_at DESC').paginate(:page => params[:page], :per_page => 9) }
        format.json { @employees = @employees.order('created_at DESC').paginate(:page => params[:page], :per_page => 9) }
      end
    end   
  end

  def forget_username_list
    @employees= Employee.joins(:user).where('"users"."forget_username" = ?', true)
    respond_to do |format|
      if params[:search]
        format.html { @employees = @employees.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 9) }
        format.json { @employees = @employees.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 9) }
      else
        format.html { @employees = @employees.order('created_at DESC').paginate(:page => params[:page], :per_page => 9) }
        format.json { @employees = @employees.order('created_at DESC').paginate(:page => params[:page], :per_page => 9) }
      end
    end     
  end

  def unblocked    
    @employee.user_created_id = current_user.id
    @employee.unblocked_employee
    @employee.temporary_password_valid
    UnblockedEmployeeMailer.unblocked_employee(@employee).deliver_now
    redirect_to blocked_user_path, notice: I18n.t('general.action.response.employee.unblocked')
  end

  def forget_username
    @employee = Employee.new    
  end

  def check_send_username
    @user = User.find_by(email: params[:employee][:email], client_type: "empleado")
    unless params[:employee][:email].empty?
      if @user.nil?
        flash[:errors] = "El correo #{params[:employee][:email]} no esta registrado como empleado."
        redirect_to forget_username_path
      else  
        @user.update_attributes(:forget_username => true)
        ForgetUsernameMailer.forget_username(@user).deliver_now
        redirect_to admin_path, notice: "La solicitud ha sido enviada"
      end
    else
      flash[:errors] = "Debe ingresar un correo electrónico."
      redirect_to forget_username_path
    end  
  end

  def resend_username
    @employee.user_created_id = current_user.id
    @employee.user.update_attributes(:forget_username => false)
    ResendUsernameMailer.resend_username(@employee).deliver_now
    redirect_to forget_username_list_path, notice: I18n.t('general.action.response.employee.forget')
  end

  def resend_password
    @employee.user_created_id = current_user.id 
    @employee.reenviar_password
    @employee.temporary_password_valid
    ResendPasswordEmployeeMailer.resend_password_employee(@employee).deliver_now
    redirect_to forget_password_path, notice: I18n.t('general.action.response.employee.resend_password')
  end



  def habilitar
    @employee.motive = params[:motive]
    if @employee.habilitar!
      @employee.registrar_motivo
      @employee.update(:user_updated_id => current_user.id)
      if $empleado=="interno"
       redirect_to employees_path, notice: I18n.t('general.action.response.employee.enable')
     else
      redirect_to employees_path, notice: I18n.t('general.action.response.employee.enable_clinic')
     end
   end
 end

  def inhabilitar
    @employee.motive = params[:motive]
    unless params[:motive].empty?  
      if @employee.inhabilitar!
        @employee.registrar_motivo
        @employee.update(:user_updated_id => current_user.id)
        if $empleado=="interno"
          redirect_to employees_path, notice: I18n.t('general.action.response.employee.disable')
        else
          redirect_to employees_path, notice: I18n.t('general.action.response.employee.disable_clinic')
        end

      end
    else
      flash[:errors] = I18n.t('general.action.response.employee.disable_employee')
      redirect_to "/employees/#{@employee.id}/motive"
    end  
  end

  def redireccionamiento_eliminar
    #usaremos este metodo para redireccionar y poder usar el input correcto cuando usemos la opcion eliminar
    $motivo = "eliminar"
    redirect_to "/employees/#{@employee.id}/motive"
  end

  #Eliminar Logico
  def eliminar_logico
    @employee.motive = params[:motive]
    unless params[:motive].empty? 
      if @employee.eliminar_logico!
        @employee.registrar_motivo
        @employee.update(:user_updated_id => current_user.id)
        if $empleado=="interno"
          redirect_to employees_path, notice: I18n.t('general.action.response.employee.delete')
        else
          redirect_to employees_path, notice: I18n.t('general.action.response.employee.delete_clinic')
        end
      end
    else

      flash[:errors] =  I18n.t('general.action.response.employee.delete_employee')
      redirect_to "/employees/#{@employee.id}/motive"
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    def title
      if $empleado == "externo"
        @titulobanner =  I18n.t ('.general.models.employees_clinic')
      else
        @titulobanner =  I18n.t ('.general.models.employees')
      end

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(
        :code_employee,
        :security_profiles_id,
        :provider_provider_id,
        :position_id,
        :second_name,
        :second_surname,
        :email,
        :first_name,
        :surname,
        :type_identification,
        :identification_document, 
        :date_valid,
        :previous_profile_security, 
        :type_profile
        )
    end

    def habilitar_user
      self.update_attributes(:user_id => @user.id)
    end

    def verificar_tipo_empleado
      if params[:empleado].present?
       $empleado = params[:empleado]
     end
   end
  def actualizar_usuario
    #si retorna true el metodo validate_username? se compara lo que esta se le asigno al attr_accersor usuario
    #con el username registrado en la tabla user, si son distintos se actualiza el username en la table USER
    #de lo contrario no realiza ninguna actualización y continua con los otros metodos
    unless @employee.user.username == params[:employee][:usuario]          
      @employee.user.update_attributes(:username => params[:employee][:usuario])
    end    
  end

  def actualizar_previous_profile_security
  
    if @employee.type_profile == "Permanente"
      if  @employee.security_profiles_id != @employee.previous_profile_security
        @employee.update_attributes(previous_profile_security: @employee.security_profiles_id)
      end
    end  
  end
 end
