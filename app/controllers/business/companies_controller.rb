class Business::CompaniesController < ApplicationController
  before_action :set_business_company, only: [:show, :edit, :update, :destroy, :habilitar,
  :inhabilitar]
  before_action :title

  # GET /business/companies
  # GET /business/companies.json
  def index
    @business_companies = Business::Company.all
  end

  # GET /business/companies/1
  # GET /business/companies/1.json
  def show
  end

  # GET /business/companies/new
  def new
    @business_company = Business::Company.new
    @business_company_types = Business::CompanyType.all
  end

  # GET /business/companies/1/edit
  def edit
  end

  # POST /business/companies
  # POST /business/companies.json
  def create
    @business_company = Business::Company.new(business_company_param)
    unless is_employee? || is_client?
      flash[:email_empleado]= nil
      respond_to do |format|
        if @business_company.save
          format.html { redirect_to root_path, notice: I18n.t('.companies.controller.create')  }
          format.json { render :show, status: :created, location: @business_company }
        else
          format.html { render :new }
          format.json { render json: @business_company.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:email_empleado] = "Existe un registro con este correo electrónico."
      render :new 
    end  
  end


  # PATCH/PUT /business/companies/1
  # PATCH/PUT /business/companies/1.json
  def update 
    @business_company.user_updated_id = current_user.id
    @company_history = HistoryPassword.find_by(password: params[:business_company][:password_company], user_id: current_user.id)
    unless is_employee? || is_client?
      flash[:email_empleado]= nil
      if params[:business_company][:password_company].present?
        unless @company_history.nil?
          if @business_company.update(business_company_param)
            if @business_company.update_email?
              respond_to do |format|
                format.html { redirect_to @business_company,notice: I18n.t('companies.controller.update_email') }
                format.json { render :show, status: :ok, location: @business_company }
              end  
            else    
              respond_to do |format|
                format.html { redirect_to @business_company, notice: I18n.t('companies.controller.update')  }
                format.json { render :show, status: :ok, location: @business_company }
              end
            end              
          else
            respond_to do |format|
              format.html { render :edit }
              format.json { render json: @business_company.errors, status: :unprocessable_entity }
            end  
          end
        else
          flash[:errors] = "Contraseña incorrecta."
          render :edit 
        end
      else
        flash[:errors] = "Por favor, introduzca contraseña."
        render :edit 
      end 
    else
      flash[:email_empleado] = "Existe un registro con este correo electrónico."
      render :edit 
    end   
  end

  # DELETE /business/companies/1
  # DELETE /business/companies/1.json
  def destroy
    @business_company.destroy
    respond_to do |format|
      format.html { redirect_to business_companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def habilitar
    if @business_company.habilitar!
      @business_company.update(:user_updated_id => current_user.id)
      redirect_to @business_company, notice: I18n.t('companies.controller.enable')
    end
  end

  #Eliminar Logico
  def inhabilitar
    if @business_company.inhabilitar!
      @business_company.update(:user_updated_id => current_user.id)
      redirect_to @business_company, notice: I18n.t('companies.controller.disable')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business_company
      @business_company = Business::Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def business_company_param
      params.require(:business_company).permit(
        :name,
        :type_identification,
        :rif,
        :email,
        :phone,
        :status,
        :address,
        :business_company_type_id,
        :firt_name_responsable,
        :last_name_responsable
      )
    end

    def is_employee?
      email_existe = User.find_by(email: @business_company.email, client_type: 'empleado')
      if email_existe.present?
        return true
      else
        return false
      end  
    end

    def is_client?
      email_existe = User.find_by(email: @business_company.email, client_type: 'persona')
      if email_existe.present?
        return true
      else
        return false
      end  
    end

    def title
      @titulobanner =  I18n.t ('.general.models.companies')
    end
end
