class MotivesController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :set_motive, only: [:show, :edit, :update, :destroy, :inhabilitar, :habilitar]
  before_action :title

  # GET /motives
  # GET /motives.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @motives = Motive.search(params[:search]).order("created_at DESC")}
        format.json { @motives = Motive.search(params[:search]).order("created_at DESC") }
      else
        format.html { @motives = Motive.all.order('created_at DESC')}
        format.json { @motives = Motive.all.order('created_at DESC')}
      end
    end
  end

  # GET /motives/1
  # GET /motives/1.json
  def show
  end

  # GET /motives/new
  def new
    @motive = Motive.new
  end

  # GET /motives/1/edit
  def edit
  end

  # POST /motives
  # POST /motives.json
  def create
    @motive = Motive.new(motive_params)
    @motive.user_created_id = current_user.id
    respond_to do |format|
      if @motive.save
        format.html { redirect_to motives_path, notice: I18n.t('motives.controller.create') }
        format.json { render :show, status: :created, location: @motive }
      else
        format.html { render :new }
        format.json { render json: @motive.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /motives/1
  # PATCH/PUT /motives/1.json
  def update
    @motive.user_updated_id = current_user.id
    respond_to do |format|
      if @motive.update(motive_params)
        format.html { redirect_to motives_path, notice: I18n.t('motives.controller.update') }
        format.json { render :show, status: :ok, location: @motive }
      else
        format.html { render :edit }
        format.json { render json: @motive.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /motives/1
  # DELETE /motives/1.json
  def destroy
    @motive.destroy
    respond_to do |format|
      format.html { redirect_to motives_url, notice: I18n.t('motives.controller.destroy') }
      format.json { head :no_content }
    end
  end

   # PUT /motives/:id/activar
  # Metodo que activa los motivos
  def habilitar
    if @motive.habilitar!
      @motive.update(:user_updated_id => current_user.id)
      redirect_to motives_path , notice: I18n.t('motives.controller.enable')
    end
  end

  # PUT /motives/:id/inactivar
  # Metodo que inactiva los motivos
  def inhabilitar
    if @motive.inhabilitar!
      @motive.update(:user_updated_id => current_user.id)
      redirect_to motives_path , notice: I18n.t('motives.controller.disable')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_motive
      @motive = Motive.find(params[:id])
    end

    def title
      @titulobanner =  I18n.t ('.general.models.motives')
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def motive_params
      params.require(:motive).permit(
        :name,
        :user_created_id,
        :user_updated_id
      )
    end
end
