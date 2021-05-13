class Business::CompanyTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :activar
  before_action :consultar
  before_action :set_business_company_type, only: [:show, :edit, :update, :destroy, :habilitar, :inhabilitar]
  before_action :title
  # GET /business/company_types
  # GET /business/company_types.json
  def index
    @business_company_types = Business::CompanyType.all
  end

  # GET /business/company_types/1
  # GET /business/company_types/1.json
  def show
  end

  # GET /business/company_types/new
  def new
    @business_company_type = Business::CompanyType.new
  end

  # GET /business/company_types/1/edit
  def edit
  end

  # POST /business/company_types
  # POST /business/company_types.json
  def create
    @business_company_type = Business::CompanyType.new(business_company_type_params)
    @business_company_type.user_created_id = current_user.id
    respond_to do |format|
      if @business_company_type.save
        format.html { redirect_to @business_company_type, notice: I18n.t('company_types.controller.create')  }
        format.json { render :show, status: :created, location: @business_company_type }
      else
        format.html { render :new }
        format.json { render json: @business_company_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /business/company_types/1
  # PATCH/PUT /business/company_types/1.json
  def update
    @business_company_type.user_updated_id = current_user.id
    respond_to do |format|
      if @business_company_type.update(business_company_type_params)
        format.html { redirect_to @business_company_type, notice: I18n.t('company_types.controller.update') }
        format.json { render :show, status: :ok, location: @business_company_type }
      else
        format.html { render :edit }
        format.json { render json: @business_company_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def habilitar
    if @business_company_type.habilitar!
      @business_company_type.update(:user_updated_id => current_user.id)
      redirect_to @business_company_type, notice: I18n.t('company_types.controller.enable')
    end
  end

  #Eliminar Logico
  def inhabilitar
    if @business_company_type.inhabilitar!
      @business_company_type.update(:user_updated_id => current_user.id)
      redirect_to @business_company_type, notice: I18n.t('company_types.controller.disable')
    end
 end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business_company_type
      @business_company_type = Business::CompanyType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def business_company_type_params
      params.require(:business_company_type).permit(
        :name,
        :limit,
        :user_updated_id
      )
    end

    def title
      @titulobanner =  I18n.t ('.company_types.title')
    end
end
