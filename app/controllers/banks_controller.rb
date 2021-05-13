class BanksController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :set_bank, only: [:show, :edit, :update, :destroy, :habilitar, :inhabilitar]
  before_action :title

  # GET /banks
  # GET /banks.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @banks = Bank.search(params[:search]).order("created_at DESC") }
        format.json { @banks = Bank.search(params[:search]).order("created_at DESC") }
      else
        format.html { @banks = Bank.all.order('created_at DESC') }
        format.json { @banks = Bank.all.order('created_at DESC')}
      end
    end
  end

  # GET /banks/1
  # GET /banks/1.json
  def show
  end

  # GET /banks/new
  def new
    @bank = Bank.new
  end

  # GET /banks/1/edit
  def edit
  end

  # POST /banks
  # POST /banks.json
  def create
    @bank = Bank.new(bank_params)
    @bank.user_created_id = current_user.id
    respond_to do |format|
      if @bank.save
        format.html { redirect_to banks_path, notice: I18n.t('banks.controller.create') }
        format.json { render :show, status: :created, location: @bank }
      else
        format.html { render :new }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /banks/1
  # PATCH/PUT /banks/1.json
  def update
    @bank.user_updated_id = current_user.id
    respond_to do |format|
      if @bank.update(bank_params)
        format.html { redirect_to banks_path, notice: I18n.t('banks.controller.update') }
        format.json { render :show, status: :ok, location: @bank }
      else
        format.html { render :edit }
        format.json { render json: @bank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /banks/1
  # DELETE /banks/1.json
  def destroy
    @bank.destroy
    respond_to do |format|
      format.html { redirect_to banks_url, notice: '' }
      format.json { head :no_content }
    end
  end

  def habilitar
    if @bank.habilitar!
      @bank.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to banks_path, notice: I18n.t('banks.controller.enable')}
        format.json { head :no_content }
      end
    end
  end

  #Eliminar Logico
  def inhabilitar
    if @bank.inhabilitar!
      @bank.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to banks_path, notice: I18n.t('banks.controller.disable') }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank
      @bank = Bank.find(params[:id])
    end

    def title
      @titulobanner =  I18n.t ('.general.models.banks')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_params
      params.require(:bank).permit(
        :name,
        :direction_web,
        :user_created_id,
        :user_updated_id,
        :image
      )
    end
    def title
      @titulobanner =  I18n.t ('.general.models.banks')
    end
end
