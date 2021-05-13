class Provider::MedicosController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :title
  before_action :set_provider_medico, only: [:show, :edit, :update, :destroy,:habilitar,
    :inhabilitar]
  before_action :eliminarVariableGlobales, only: [:new]

  # GET /provider/medicos
  # GET /provider/medicos.json
  def index
    @provider_medico = Provider::Medico.new
    if @provider_medico.verificar_empleado_externo?(current_user.id)
      respond_to do |format| 
        if params[:search]
          format.html { @provider_medicos = Provider::Medico.search(params[:search]).order("created_at DESC")}
          format.json { @provider_medicos = Provider::Medico.search(params[:search]).order("created_at DESC")}
        else
          format.html { @provider_medicos = Provider::Medico.all.order('created_at DESC')}
          format.json { @provider_medicos = Provider::Medico.all.order('created_at DESC')}
        end
      end
    else
      @provider = Provider::Provider.find(current_user.employee.provider_provider_id)
      params[:search] = @provider.name
       @provider_medicos = Provider::Medico.where(status: 'Activo')
      respond_to do |format| 
        if params[:search]
          format.html { @provider_medicos = @provider_medicos.search(params[:search]).order("created_at DESC")}
          format.json { @provider_medicos = @provider_medicos.search(params[:search]).order("created_at DESC")}
        else
          format.html { @provider_medicos = @provider_medicos.all.order('created_at DESC')}
          format.json { @provider_medicos = @provider_medicos.all.order('created_at DESC')}
        end
      end
    end 
  end

  # GET /provider/medicos/1
  # GET /provider/medicos/1.json
  def show
    @provider_medico_provider = Provider::MedicoProvider.where(provider_medico_id: params[:id])
  end

  # GET /provider/medicos/new
  def new
    @provider_medico = Provider::Medico.new
    @provider_medico.build_people
    @provider_providers = Provider::Provider.all
    @provider_medico_provider = Provider::MedicoProvider.new
    @provider_medico.verificar_empleado_externo?(current_user.id)
  end

  # GET /provider/medicos/1/edit
  def edit
    @provider_medico_provider = Provider::MedicoProvider.new
    @people = People.find_by id: @provider_medico.people_id
    @medico_providers = Provider::MedicoProvider.where(provider_medico_id: params[:id])
    @provider_providers = Provider::Provider.all
    unless $medicoProvider.nil?
      $medicoProvider = Provider::Medico.find(params[:id])
    end
  end

  # POST /provider/medicos
  # POST /provider/medicos.json
  def create
    @provider_medico = Provider::Medico.new(provider_medico_params)
    @provider_medico.user_created_id = current_user.id
    inicializar_attr_accessor
    respond_to do |format|
      @people= People.where(identification_document:  @provider_medico.people.identification_document).first
      unless @people.nil?
        if @people.provider_medico.nil?
          @provider_medico.people = nil
          @provider_medico.people_id = @people.id
        end
      end 
      if @provider_medico.save
        if  @provider_medico.verificar_empleado_externo?(current_user.id)
          format.html { redirect_to @provider_medico, notice: I18n.t('.medicos.controller.create') }
          format.json { render :show, status: :created, location: @provider_medico }
          format.js  { render 'provider/medicos/create.js.erb' }
        else 
          @provider_medico_provider = Provider::MedicoProvider.new
          @employee = Employee.find_by(user_id: current_user.id)
          @provider_medico_provider.provider_provider_id =  @employee.provider_provider_id
          @provider_medico_provider.provider_medico_id =  @provider_medico.id
          @provider_medico_provider.user_created_id = current_user.id
          @provider_medico_provider.save
        end
        format.html { redirect_to @provider_medico, notice: I18n.t('.medicos.controller.create') }
        format.json { render :show, status: :created, location: @provider_medico }

      else
        if  @provider_medico.verificar_empleado_externo?(current_user.id)
          format.html { render :new }
          format.json { render json: @provider_medico.errors, status: :unprocessable_entity }
          format.js   { render json: @provider_medico.errors, status: :unprocessable_entity }
        else 
          @persona = People.find_by(identification_document: @provider_medico.people.identification_document)
          @medico = Provider::Medico.find_by(people_id: @persona.id)
          unless @provider_medico.verificar_medico?(@medico,current_user.id)
            format.html { redirect_to provider_medicos_path, notice: I18n.t('.medicos.controller.create') }
          else
            format.html { render :new }
            format.json { render json: @provider_medico.errors, status: :unprocessable_entity }
            format.js   { render json: @provider_medico.errors, status: :unprocessable_entity }
          end
        end
      end
    end
  end

# PATCH/PUT /provider/medicos/1
# PATCH/PUT /provider/medicos/1.json
def update
  $medicoProvider = Provider::Medico.find(params[:id])
  params[:provider_medico][:provider_providers] ||=[]
  inicializar_attr_accessor
  @provider_medico.user_updated_id = current_user.id
  respond_to do |format|
    if @provider_medico.update(provider_medico_params)
      if  @provider_medico.verificar_empleado_externo?(current_user.id)
        format.html { redirect_to @provider_medico, notice: I18n.t('customers.controller.update') }
        format.json { render :show, status: :ok, location: @provider_medico }
        format.js  { render 'provider/medicos/create.js.erb' }
      else
        @provider_medico.verificar_medico?(@provider_medico,current_user.id)
        format.html { redirect_to @provider_medico, notice: I18n.t('customers.controller.update') }
        format.json { render :show, status: :ok, location: @provider_medico }
      end 
    else
      format.html { render :edit }
      format.json { render json: @provider_medico.errors, status: :unprocessable_entity }
    end
  end
end

  def habilitar
    if @provider_medico.habilitar!
      @provider_medico.update(:user_updated_id => current_user.id)
      redirect_to @provider_medico, notice: I18n.t('medicos.controller.enable')
    end
  end

  #Eliminar Logico
  def inhabilitar
    if @provider_medico.inhabilitar!
      @provider_medico.update(:user_updated_id => current_user.id)
      redirect_to @provider_medico, notice: I18n.t('medicos.controller.disable')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_provider_medico
      @provider_medico = Provider::Medico.find(params[:id])
    end

    def title
      @titulobanner =  I18n.t ('.general.models.doctors')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def provider_medico_params
      params.require(:provider_medico).permit(
        :code_medico,
        :c_m_l,
        :speciality_id, 
        :phone_medico,
        :people_attributes => [
          :id,
          :first_name,
          :surname,
          :type_identification,
          :identification_document,
          :email,
          :date_birth,
          :sex,
          :civil_status,
          :cellphone,
          :address
        ]
        )
    end

    def eliminarVariableGlobales
      $medicoProvider = nil
    end
    def inicializar_attr_accessor
      @provider_medico.people.beneficiario = false
      @provider_medico.people.employee = false
      @provider_medico.people.cliente = false
    end

  end
