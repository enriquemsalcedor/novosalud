class PositionsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :set_position, only: [:show, :edit, :update, :destroy, :habilitar, :inhabilitar]
  before_action :title

  # GET /positions
  # GET /positions.json
  def index
    @positions = Position.all
  end

  # GET /positions/1
  # GET /positions/1.json
  def show
  end

  # GET /positions/new
  def new
    @position = Position.new
  end

  # GET /positions/1/edit
  def edit
  end

  # POST /positions
  # POST /positions.json
  def create
    @position = Position.new(position_params)

    respond_to do |format|
      if @position.save
        format.html { redirect_to positions_path,notice: I18n.t('.general.controller.create') }
        format.json { render :show, status: :created, location: @position }
      else
        format.html { render :new }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /positions/1
  # PATCH/PUT /positions/1.json
  def update
    respond_to do |format|
      if @position.update(position_params)
        format.html { redirect_to positions_path, notice: I18n.t('.general.controller.updated')}
        format.json { render :show, status: :ok, location: @position }
      else
        format.html { render :edit }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.json
  def destroy
    @position.destroy
    respond_to do |format|
      format.html { redirect_to positions_url, notice: 'Position was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def habilitar
    if @position.habilitar!
      @position.update(:user_updated_id => current_user.id)
      redirect_to positions_path, notice: I18n.t('general.controller.enable')
    end
  end

  def title
    @titulobanner =  I18n.t ('.general.models.positions')
  end
  #Eliminar Logico
  def inhabilitar
    if @position.inhabilitar!
      @position.update(:user_updated_id => current_user.id)
      redirect_to positions_path, notice: I18n.t('general.controller.disable')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_params
      params.require(:position).permit(:name, :description)
    end
end
