class CustomersController < ApplicationController
  before_action :title
  before_action :set_customer, only: [:show, :edit, :update, :habilitar,
  :inhabilitar, :is_employee]

  # GET /customers
  # GET /customers.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @customers = Customer.search(params[:search]).order("created_at DESC")}
        format.json { @customers = Customer.search(params[:search]).order("created_at DESC")}
      else
        format.html { @customers = Customer.all.order('created_at DESC')}
        format.json { @customers = Customer.all.order('created_at DESC')}
      end
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    @customer.build_people
    inicializar_attr_accessor
  end

  # GET /customers/1/edit
  def edit
    @people = People.find_by id: @customer.people_id
    @user = User.find_by id: @customer.user_id
    inicializar_attr_accessor
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)
    inicializar_attr_accessor
    unless is_employee? || is_company?
      unless is_cedula?
        flash[:email_empleado]= nil
        @customer.existe_persona
        respond_to do |format|
          if @customer.save
            format.html { redirect_to root_path, notice: I18n.t('.customers.controller.create') }
            format.json { render :show, status: :created, location: @customer }
          else
            format.html { render :new }
            format.json { render json: @customer.errors, status: :unprocessable_entity }
          end
        end
      else
        flash[:cedula_existe] = "Existe un registro con esta cédula de identidad."
        render :new 
      end  
    else 
      flash[:email_empleado] = "Existe un registro con este correo electrónico."
      render :new 
    end   
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    @customer_history = HistoryPassword.find_by(password: params[:customer][:password_customer], user_id: current_user.id)
    unless is_employee? || is_company?
      flash[:email_empleado]= nil
      if params[:customer][:password_customer].present?
        unless @customer_history.nil?
          @customer.user_updated_id = current_user.id
          inicializar_attr_accessor
          if @customer.update(customer_params)
            if @customer.update_email?
              respond_to do |format|
                format.html { redirect_to @customer,notice: I18n.t('customers.controller.update_email') }
                format.json { render :show, status: :ok, location: @customer }
              end
            else     
              respond_to do |format|
                #@customer.user_updated_id = current_user.id
                format.html { redirect_to @customer,notice: I18n.t('customers.controller.update') }
                format.json { render :show, status: :ok, location: @customer }
              end
            end
          else
            respond_to do |format|
              format.html { render :edit }
              format.json { render json: @customer.errors, status: :unprocessable_entity }
            end
          end
        else
          flash[:errors] = "Contraseña incorrecta."
          redirect_to edit_customer_path
        end
      else
        flash[:errors] = "Por favor, introduzca contraseña."
        redirect_to edit_customer_path
      end 
    else
      flash[:email_empleado] = "Existe un registro con este correo electrónico."
      render :new
    end 
end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def habilitar
    if @customer.habilitar!
      @customer.update(:user_updated_id => current_user.id)
      redirect_to @customer, notice: I18n.t('customers.controller.enable')
    end
  end

  #Eliminar Logico
  def inhabilitar
    if @customer.inhabilitar!
      @customer.update(:user_updated_id => current_user.id)
      redirect_to @customer, notice: I18n.t('customers.controller.disable')
    end
  end

  def title
    @titulobanner =  I18n.t ('.general.models.customers')
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    def is_employee?
      email_existe = User.find_by(email: @customer.people.email, client_type: 'empleado')
      if email_existe.present?
        return true
      else
        return false
      end  
    end

    def is_company?
      email_existe = User.find_by(email: @customer.people.email, client_type: 'empresa')
      if email_existe.present?
        return true
      else
        return false
      end  
    end

    def is_cedula?
      cedula_existe = People.find_by(identification_document: @customer.people.identification_document)
#      cedula_existe_empleado = Employee.find_by(identification_document: @customer.people.identification_document)

      if cedula_existe.present?
        return true
#      elsif cedula_existe_empleado.present?
#        return true
      else  
        return false
      end  
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:customer_code, :people_attributes => [:id, :first_name,:surname, :type_identification,
       :identification_document, :email, :date_birth, :sex, :civil_status, :phone, :cellphone, :address])
    end

    def inicializar_attr_accessor
      @customer.people.beneficiario = false
      @customer.people.employee = false
      @customer.people.cliente = true
    end
end
