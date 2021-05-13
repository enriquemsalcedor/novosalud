class Sale::ProductQuotationsController < ApplicationController
  before_action :set_sale_product_quotation, only: [:show, :edit, :update, :destroy]
  before_action :obtener_cotizacion, only: [:create]


  # GET /sale/product_quotations
  # GET /sale/product_quotations.json
  def index
    @sale_product_quotations = Sale::ProductQuotation.all
  end

  # GET /sale/product_quotations/1
  # GET /sale/product_quotations/1.json
  def show
  end

  # GET /sale/product_quotations/new
  def new
    @sale_product_quotation = Sale::ProductQuotation.new
  end

  # GET /sale/product_quotations/1/edit
  def edit
  end

  # POST /sale/product_quotations
  # POST /sale/product_quotations.json
  def create
    @sale_product_quotation = Sale::ProductQuotation.new(sale_product_quotation_params)
    @sale_product_quotation.sale_quotation_id = session[:user_car]
    if user_signed_in?
      @sale_product_quotation.user_created_id = current_user.id
    end
    @existeproducto = Sale::ProductQuotation.find_by(product_product_id: $productid, sale_quotation_id: session[:user_car])
    if @existeproducto.nil?
      respond_to do |format|
        if @sale_product_quotation.save!
          format.html { redirect_to '/list', notice: 'Se ha añadido satisfactoriamente este producto a la cotización' }
          format.json { render :show, status: :created, location: @sale_product_quotation }
        else
          format.html { render :new }
          format.json { render json: @sale_product_quotation.errors, status: :unprocessable_entity }
        end
      end
    else
      @cantidad = @sale_product_quotation.quantity  + @existeproducto.quantity
      respond_to do |format|
        if @cantidad <= 100
          if @existeproducto.update(:quantity => @cantidad)
            if user_signed_in?
              @existeproducto.update(:user_updated_id => current_user.id)
            end
            format.html { redirect_to '/list', notice: 'Se ha añadido satisfactoriamente este producto a la cotización' }
          end
        else
          @nombre = Product::Product.find_by(id: $productid)
          format.html { redirect_to '/list', notice: 'Se ha excedido la cantidad màxima de 100 unidades para el producto : '+@nombre.nombre}
        end
      end
    end
  end

  def actualizar_cantidad_producto
    @product = Sale::ProductQuotation.find(params[:id])
    respond_to do |format|
      if @product.update(:quantity => params[:quantity])
        unless current_user.nil?
          @product.update(:user_updated_id => current_user.id)
        end
        @total = "%.2f" % (@product.quantity * @product.product_product.price)
        format.js { render "sale/product_quotations/actualizar_precio.js.erb"}
      end
    end
  end
  # PATCH/PUT /sale/product_quotations/1
  # PATCH/PUT /sale/product_quotations/1.json
  def update
    @sale_product_quotation.user_updated_id = current_user.id
    respond_to do |format|
      if @sale_product_quotation.update(sale_product_quotation_params)
        format.html { redirect_to @sale_product_quotation, notice: 'Se ha actualizado satisfactoriamente este producto en la cotización.' }
        format.json { render :show, status: :ok, location: @sale_product_quotation }
      else
        format.html { render :edit }
        format.json { render json: @sale_product_quotation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sale/product_quotations/1
  # DELETE /sale/product_quotations/1.json

  def destroy
    @product = Sale::ProductQuotation.find(params[:id])
    @sale_product_quotation.destroy
    respond_to do |format|
      format.html { redirect_to sale_product_quotation_url, notice: 'Producto eliminado con exitó' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sale_product_quotation
      @sale_product_quotation = Sale::ProductQuotation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sale_product_quotation_params
      params.require(:sale_product_quotation).permit(:sale_quotation_id, :product_product_id, :quantity)
    end

    # Metodo que me permite buscar si el usuario tiene asociado una cotizacion con estatus en cotizacion al momento de
    # agregar un producto a la cotizacion
     def obtener_cotizacion
        unless current_user.nil?
          @sale_quotation = Sale::Quotation.find_by(user_id: current_user.id, status: :En_cotizacion)  
            unless @sale_quotation.nil?
              session[:user_car] =  @sale_quotation.id
            else
              @sale_quotation = Sale::Quotation.create(:user_id => current_user.id, :user_created_id => current_user.id)
              session[:user_car] =  @sale_quotation.id
            end
        else
          @cotizacion_temporal = Sale::Quotation.find_by(ip_quotation: request.remote_ip, user_id: nil)  
            unless @cotizacion_temporal.nil?
              session[:user_car] =  @cotizacion_temporal.id
            else
              @cotizacion_temporal = Sale::Quotation.create(:ip_quotation => request.remote_ip)
              session[:user_car] =  @cotizacion_temporal.id
            end
        end
     end

end
