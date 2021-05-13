class Product::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear 
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :title
  before_action :set_product_product, only: [:show, :edit, :update, :destroy, :inhabilitar, :habilitar]

  # GET /product/products
  # GET /product/products.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @product_products = Product::Product.search(params[:search]).order("created_at DESC")}
        format.json { @product_products = Product::Product.search(params[:search]).order("created_at DESC")}
      else
        format.html { @product_products = Product::Product.all.order('created_at DESC')}
        format.json { @product_products = Product::Product.all.order('created_at DESC')}
      end
    end
  end


  # GET /product/products/1
  # GET /product/products/1.json
  def show
  end

  # GET /product/products/new
  def new
    @product_product = Product::Product.new
  end

  # GET /product/products/1/edit
  def edit
  end

  # POST /product/products
  # POST /product/products.json
  def create
    @product_product = Product::Product.new(product_product_params)
    @product_product.user_created_id = current_user.id
    respond_to do |format|
      if @product_product.save
        @product_product.activar_producto
        format.html { redirect_to product_products_path, notice: I18n.t('products.controller.create')  }
        format.json { render :show, status: :created, location: @product_product }
      else
        format.html { render :new }
        format.json { render json: @product_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product/products/1
  # PATCH/PUT /product/products/1.json
  def update
    @product_product.user_updated_id = current_user.id
    respond_to do |format|
      if @product_product.update(product_product_params)
        format.html { redirect_to product_products_path, notice: I18n.t('products.controller.update') }
        format.json { render :show, status: :ok, location: @product_product }
      else
        format.html { render :edit }
        format.json { render json: @product_product.errors, status: :unprocessable_entity }
      end
    end
  end



  # PUT /specialities/:id/activar
  # Metodo que activa las especialidades
  def habilitar
    if @product_product.habilitar!
      # Se obtiene el id del ultimo job para asignarlo al atributo job_id de "product_products"
      # por si la fecha de expiracion del producto es modificada, la fecha de ejecucion del job (run_at)
      # sea actualizada a la nueva fecha de expiracion del paquete
      job = Delayed::Job.last
      @product_product.update(:job_id => job.id)

      @product_product.update(:user_updated_id => current_user.id)
      redirect_to product_products_path , notice: I18n.t('products.controller.enable')
    end
  end

  # PUT /specialities/:id/inactivar
  # Metodo que inactiva las especialidades
  def inhabilitar
    if @product_product.inhabilitar!
      @product_product.update(:user_updated_id => current_user.id)
      #Se pasa a nil el atributo job_id cuando se elimina el job
        @product_product.update(:job_id => nil)
      redirect_to product_products_path , notice: I18n.t('products.controller.disable')
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_product
      @product_product = Product::Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_product_params
      params.require(:product_product).permit(
        :code, 
        :name,
        :description,  
        :category, 
        :terms, 
        :publication_date, 
        :expiration_date, 
        :status, 
        :speciality_id, 
        :product_product_type_id, 
        :price, 
        :provider_provider_id, 
        :user_created_id, 
        :user_updated_id,
        :image,
        :valid_days
        )
    end

    def title
      @titulobanner =  I18n.t ('.general.models.products')
    end
end
