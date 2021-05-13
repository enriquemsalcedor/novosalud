class Sale::PackageQuotation < ApplicationRecord

  belongs_to :sale_quotation, class_name: Sale::Quotation, foreign_key: :sale_quotation_id
  belongs_to :colection_package, class_name: Colection::Package, foreign_key: :colection_package_id

  validates :quantity, :presence => {:message => "Debe ingresar una cantidad."}, :numericality => {:only_integer => true, :message => "La cantidad debe ser un número entero."}
  def monto_pagar
    self.quantity * self.colection_package.total_amount
  end
end
