class Colection::PackagesController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :activar
  before_action :consultar
  before_action :title
  before_action :set_colection_package, only: [:show, :edit, :update, :destroy, :inhabilitar, :habilitar]
  before_action :eliminar_variable_Globales, only: [:new]

  # GET /colection/packages
  # GET /colection/packages.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @colection_packages = Colection::Package.search(params[:search]).order("created_at DESC")}
        format.json { @colection_packages = Colection::Package.search(params[:search]).order("created_at DESC")}
      else
        format.html { @colection_packages = Colection::Package.all.order('created_at DESC')}
        format.json { @colection_packages = Colection::Package.all.order('created_at DESC')}
      end
    end
  end
  # GET /colection/packages/1
  # GET /colection/packages/1.json
  def show
    @package_products = Colection::PackageProduct.where(colection_package_id: params[:id])
  end

  # GET /colection/packages/new
  def new
    @colection_package = Colection::Package.new
    @colection_package_product = Colection::PackageProduct.new
  end

  # GET /colection/packages/1/edit
  def edit
    $package = Colection::Package.find(params[:id])
    @colection_package_product = Colection::PackageProduct.new
  end

  # POST /colection/packages
  # POST /colection/packages.json
  def create
    @colection_package = Colection::Package.new(colection_package_params)
    @colection_package.user_created_id = current_user.id
    respond_to do |format|
      if @colection_package.save
        @colection_package.verificar_paquete_nuevo= false
        format.html { redirect_to @colection_package, notice: 'Se creó con éxito el paquete.' }
        format.json { render :show, status: :created, location: @colection_package }
        format.js   { render 'colection/packages/create.js.erb'  }
      else
        format.html { render :new }
        format.json { render json: @colection_package.errors, status: :unprocessable_entity }
        format.js   { render json: @colection_package.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /colection/packages/1
  # PATCH/PUT /colection/packages/1.json
  def update
    @package_products = Colection::PackageProduct.where(colection_package_id: params[:id])
    respond_to do |format|
      @colection_package.user_updated_id = current_user.id
      if params[:variable].blank?
        @colection_package.cambio_categoria= 0
      else
        @colection_package.cambio_categoria= params[:variable]
      end
      if @colection_package.update(colection_package_params)
        @colection_package.verificar_paquete_nuevo= true
        format.html { redirect_to @colection_package, notice: 'Se actualizó con éxito el paquete.' }
        format.json { render :show, status: :ok, location: @colection_package }
        format.js   { render 'colection/packages/create.js.erb' }

      else
        format.html { render :edit }
        format.json { render json: @colection_package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /colection/packages/1
  # DELETE /colection/packages/1.json
  def destroy
    @colection_package.destroy
    respond_to do |format|
      format.html { redirect_to colection_packages_url, notice: 'Se eliminó con éxito el paquete.' }
      format.json { head :no_content }
    end
  end

  def habilitar
    unless @colection_package.product_products.empty?
      if @colection_package.habilitar!
        @colection_package.update(:user_updated_id => current_user.id)
          # Se obtiene el id del ultimo job para asignarlo al atributo job_id de "colection_package"
          # por si la fecha hasta de la validez del paquete es modificada, la fecha de ejecucion del job (run_at)
          # sea actualizada a la nueva vigencia hasta del paquete
          job = Delayed::Job.last
          @colection_package.update(:job_id => job.id)
          respond_to do |format|
            format.html { redirect_to colection_packages_path, notice: "Se habilitó con éxito el paquete."}
            format.json { head :no_content }
          end
        end
      else
        redirect_to colection_packages_path , notice: "No se puede habilitar un paquete sin productos asociados"
      end
    end

  #Eliminar Logico
  def inhabilitar
    if @colection_package.inhabilitar!
      @colection_package.update(:user_updated_id => current_user.id)
        #Se pasa a nil el atributo job_id cuando se elimina el job
        @colection_package.update(:job_id => nil)
        respond_to do |format|
          format.html { redirect_to colection_packages_path, notice: "Se inhabilitó con éxito el paquete." }
          format.json { head :no_content }
        end
      end
    end

  #Método para eliminar los productos asociado al paquete, siempre y cuando el usuario así lo decida.
  def destroy_package_product
    @colection_package_products = Colection::PackageProduct.where(colection_package_id: params[:id])
    @colection_package_products.each do |package_product| 
      package_product.destroy
    end
    respond_to do |format|
      format.js { render "colection/packages/destroy_products.js.erb"}
    end
  end

  #Método que permite verificar si el paquete tiene producto, y si el usuario desea eliminar los mismos.
  def verificar_productos
    @colection_package_products = Colection::PackageProduct.where(colection_package_id: params[:id])
    if @colection_package_products.empty?
      @var= {respuesta: '1'}
    else  
      $categoria= @colection_package_products[0].colection_package.category
      @var= {respuesta: '2', categoria: $categoria }
    end
    render :json =>@var
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_colection_package
      @colection_package = Colection::Package.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def colection_package_params

      params.require(:colection_package).permit(
        :description,
        :valid_since,
        :valid_until,
        :total_amount,
        :category,
        :terms,
        :status,
        :image
        )
    end

    def title
      @titulobanner =  I18n.t ('.general.models.packages')
    end

    def eliminar_variable_Globales
      $package =nil
    end


  end
