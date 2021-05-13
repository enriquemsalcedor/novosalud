class Product::ProductTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :crear 
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :set_product_product_type, only: [:show, :edit, :update, :destroy, :inhabilitar, :habilitar]
  before_action :title

  # GET /product/product_types
  # GET /product/product_types.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @product_product_types = Product::ProductType.search(params[:search]) }
        format.json { @product_product_types = Product::ProductType.search(params[:search])}
      else
        format.html { @product_product_types = Product::ProductType.all.order('created_at DESC')}
        format.json { @product_product_types = Product::ProductType.all.order('created_at DESC')}
      end
    end
  end

  # GET /product/product_types/1
  # GET /product/product_types/1.json
  def show
  end

  # GET /product/product_types/new
  def new
    @product_product_type = Product::ProductType.new
  end

  # GET /product/product_types/1/edit
  def edit
  end

  # POST /product/product_types
  # POST /product/product_types.json
  def create
    @product_product_type = Product::ProductType.new(product_product_type_params)
    @product_product_type.user_created_id = current_user.id
    respond_to do |format|
      if @product_product_type.save
        format.html { redirect_to product_product_types_path, notice: I18n.t('product_types.controller.create') }
        format.json { render :show, status: :created, location: @product_product_type }
      else
        format.html { render :new }
        format.json { render json: @product_product_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product/product_types/1
  # PATCH/PUT /product/product_types/1.json
  def update
    @product_product_type.user_updated_id = current_user.id
    respond_to do |format|
      if @product_product_type.update(product_product_type_params)
        format.html { redirect_to product_product_types_path, notice: I18n.t('product_types.controller.update') }
        format.json { render :show, status: :ok, location: @product_product_type }
      else
        format.html { render :edit }
        format.json { render json: @product_product_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product/product_types/1
  # DELETE /product/product_types/1.json
  def destroy
    @product_product_type.destroy
    respond_to do |format|
      format.html { redirect_to product_product_types_url, notice: I18n.t('product_types.controller.destroy') }
      format.json { head :no_content }
    end
  end

  # PUT /specialities/:id/activar
  # Metodo que activa los tipos de productos
  def habilitar
    if @product_product_type.habilitar!
      @product_product_type.update(:user_updated_id => current_user.id)
      redirect_to product_product_types_path , notice: I18n.t('product_types.controller.enable')
    end
  end

  # PUT /specialities/:id/inactivar
  # Metodo que inactiva los tipos de productos
  def inhabilitar
    if @product_product_type.inhabilitar!
      @product_product_type.update(:user_updated_id => current_user.id)
      redirect_to product_product_types_path , notice: I18n.t('product_types.controller.disable')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_product_type
      @product_product_type = Product::ProductType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_product_type_params
      params.require(:product_product_type).permit(:name, :description, :user_created_id, :user_updated_id, :status)
    end

    def title
      @titulobanner =  I18n.t ('.general.models.products_types')
    end
  end
