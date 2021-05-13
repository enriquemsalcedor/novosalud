class AccountsController < ApplicationController
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :set_account, only: [:show, :edit, :update, :destroy, :habilitar, :inhabilitar]

  # GET /accounts
  # GET /accounts.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @accounts = Account.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 9) }
        format.json { @accounts = Account.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 9) }
      else
        format.html { @accounts = Account.all.order('created_at DESC').paginate(:page => params[:page], :per_page => 9) }
        format.json { @accounts = Account.all.order('created_at DESC').paginate(:page => params[:page], :per_page => 9) }
      end
    end
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @account = Account.new(account_params)
    @account.user_created_id = current_user.id
    respond_to do |format|
      if @account.save
        format.html { redirect_to accounts_path, notice: I18n.t('account.controller.create') }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    @account.user_updated_id = current_user.id
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to accounts_path, notice: I18n.t('account.controller.update') }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: I18n.t('account.controller.destroy') }
      format.json { head :no_content }
    end
  end

  def habilitar
    if @account.habilitar!
      @account.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to accounts_path, notice: I18n.t('account.controller.enable')}
        format.json { head :no_content }
      end
    end
  end

  #Eliminar Logico
  def inhabilitar
    if @account.inhabilitar!
      @account.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to accounts_path, notice: I18n.t('account.controller.disable') }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:bank_id, :account_number, :account_type,:email, :user_created_id, :user_updated_id, :status )
    end
end
