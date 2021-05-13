class SpecialitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :set_speciality, only: [:show, :edit, :update, :destroy, :inhabilitar, :habilitar]
  before_action :title

  # GET /specialities
  # GET /specialities.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @specialities = Speciality.search(params[:search]).order("created_at DESC")}
        format.json { @specialities = Speciality.search(params[:search]).order("created_at DESC")}
      else
        format.html { @specialities = Speciality.all.order('created_at DESC')}
        format.json { @specialities = Speciality.all.order('created_at DESC')}
      end
    end
  end

  # GET /specialities/1
  # GET /specialities/1.json
  def show
  end

  # GET /specialities/new
  def new
    @speciality = Speciality.new
  end

  # GET /specialities/1/edit
  def edit
  end

  # POST /specialities
  # POST /specialities.json
  def create
    @speciality = Speciality.new(speciality_params)
    @speciality.user_created_id = current_user.id
    respond_to do |format|
      if @speciality.save
        format.html { redirect_to specialities_path, notice: I18n.t('specialities.controller.create')}
        format.json { render :show, status: :created, location: @speciality }

      else
        format.html { render :new }
        format.json { render json: @speciality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /specialities/1
  # PATCH/PUT /specialities/1.json
  def update
    @speciality.user_updated_id = current_user.id
    respond_to do |format|
      if @speciality.update(speciality_params)
        format.html { redirect_to specialities_path, notice: I18n.t('specialities.controller.update') }
        format.json { render :show, status: :ok, location: @speciality }
      else
        format.html { render :edit }
        format.json { render json: @speciality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /specialities/:id/activar
  # Metodo que activa las especialidades
  def habilitar
    if @speciality.habilitar!
      @speciality.update(:user_updated_id => current_user.id)
      redirect_to specialities_path , notice: I18n.t('specialities.controller.enable')
    end
  end

  # PUT /specialities/:id/inactivar
  # Metodo que inactiva las especialidades
  def inhabilitar
    if @speciality.inhabilitar!
      @speciality.update(:user_updated_id => current_user.id)
      redirect_to specialities_path , notice: I18n.t('specialities.controller.disable')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_speciality
      @speciality = Speciality.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def speciality_params
      params.require(:speciality).permit(
        :name,
        :description,
        :user_created_id,
        :user_updated_id
      )
    end

    def title
      @titulobanner =  I18n.t ('.general.models.specialities')
    end

    def nombre
      @nombre =  Organization.unico
    end
end

