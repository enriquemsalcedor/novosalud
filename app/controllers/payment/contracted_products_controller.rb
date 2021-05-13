class Payment::ContractedProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :activar
  before_action :consultar
  before_action :tittle
  before_action :set_payment_contracted_product

  def index
    @payment_plan = Payment::Plan.where(status: "Activo")
    respond_to do |format|
      if params[:search]
        format.html { @payment_plan = Payment::Plan.search(params[:search]).order("created_at DESC")}
        format.json { @payment_plan = Payment::Plan.search(params[:search]).order("created_at DESC")}
        format.xlsx { @payment_plan = Payment::Plan.search(params[:search]).order("created_at DESC")}
      else
        @payment_plan = Payment::Plan.all.order('created_at DESC')
        format.html { @payment_plan = Payment::Plan.all.order('created_at DESC')}
        format.json { @payment_plan = Payment::Plan.all.order('created_at DESC')}
        format.xlsx {render template: 'payment/contracted_products/index.xlsx', xlsx: 'Productos Pagados' }
      end
    end

  end

  def show
    @payment_contracted_product = Payment::ContractedProduct.where(plan_id: params[:id])
  end

  private

# Use callbacks to share common setup or constraints between actions.
def set_payment_contracted_product
  @payment_plan = Payment::Plan.find_by(id: params[:id])
end


def tittle
  @titulobanner =  "Activación de Producto"
end


end
