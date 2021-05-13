class Payment::CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :activar
  before_action :consultar
  def index
    @quotation_act = Sale::Quotation.vigentes
    @quotation_venc = Sale::Quotation.vencidas
  end

  def show
  	@quotation = Sale::Quotation.find_by(id: params[:id])
    @product_quotations = Sale::ProductQuotation.where(sale_quotation_id: params[:id])
    @package_quotations = Sale::PackageQuotation.where(sale_quotation_id: params[:id])

  end

  def pay
  	@quotation = Sale::Quotation.find_by(id: params[:id])
    @costumer = @quotation.user.customer.people.id
    # @company = @quotation.user.company.id
    @product_quotation = Sale::ProductQuotation.new
    @product_quotations = Sale::ProductQuotation.where(sale_quotation_id: params[:id])
    @package_quotations = Sale::PackageQuotation.where(sale_quotation_id: params[:id])
    @payment_plan = Payment::Plan.new

  end

  
  def reactivar
    if @payment_plan.sale_quotation.reactivar!
      @payment_plan.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to @payment_plan, notice: "Se reactivo con éxito la cotización."}
        format.json { head :no_content }
      end
    end
  end

end
