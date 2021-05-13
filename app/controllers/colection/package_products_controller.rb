class Colection::PackageProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :activar
  before_action :consultar
  before_action :set_colection_package_product, only: [:show, :edit, :update, :destroy]
  # GET /colection/package_products
  # GET /colection/package_products.json
  def index
    @colection_package_products = Colection::PackageProduct.all
  end

  # GET /colection/package_products/1
  # GET /colection/package_products/1.json
  def show
  end

  # GET /colection/package_products/new
  def new
  end

  # GET /colection/package_products/1/edit
  def edit
    @package_product = PackageProduct.new
  end

  # POST /colection/package_products
  # POST /colection/package_products.json
  def create
    @package_product = Colection::PackageProduct.new(colection_package_product_params)
    unless $package.nil?
      @package = $package
    else
      @package = Colection::Package.last
    end

    unless @package.nil?
      @package_product.colection_package_id = @package.id
    end
    @package_product.user_created_id = current_user.id
    @existeproducto = Colection::PackageProduct.find_by(product_product_id: @package_product.product_product_id, colection_package_id: @package_product.colection_package_id)
    if @existeproducto.nil?

      respond_to do |format|
        if @package_product.save
          format.html { redirect_to @package_product, notice: 'Se creó con éxito el producto para este paquete' }
          format.json { render :show, status: :created, location: @package_product }
          format.js   { render 'colection/package_products/create.js.erb' }
        else
          format.html { render :new }
          format.json { render json: @package_product.errors, status: :unprocessable_entity }
        end
      end
    else
      @cantidad = @package_product.quantity  + @existeproducto.quantity
      respond_to do |format|
        if @existeproducto.update(:quantity => @cantidad)
          format.json { render :show, status: :created, location: @package_product }
          format.js   { render :js => "$('td##{@package_product.product_product_id}').html('#{@cantidad}');
                                       $('#colection_package_product_product_product_id option').prop('selected', function() {
                                        return this.defaultSelected; });" }
        end

      end
    end
  end

  # PATCH/PUT /colection/package_products/1
  # PATCH/PUT /colection/package_products/1.json
  def update
    respond_to do |format|
      @colection_package_product.user_updated_id = current_user.id
      if @colection_package_product.update(colection_package_product_params)
        format.html { redirect_to @colection_package_product, notice: 'Paquete actualizado exitosamente.' }
        format.json { render :show, status: :ok, location: @colection_package_product }
      else
        format.html { render :edit }
        format.json { render json: @colection_package_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /colection/package_products/1
  # DELETE /colection/package_products/1.json
  def destroy
    @colection_package_product.destroy
    respond_to do |format|
      format.html { redirect_to colection_package_products_url, notice: 'Paquete eliminado exitosamente.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_colection_package_product
      @colection_package_product = Colection::PackageProduct.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def colection_package_product_params
      params.require(:colection_package_product).permit(
        :quantity,
        :user_created_id,
        :user_updated_id,
        :product_product_id,
        :colection_package_id
        )
    end
end
