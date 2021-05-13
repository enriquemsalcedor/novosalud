class Sale::ProductQuotation < ApplicationRecord
  belongs_to :sale_quotation, class_name: Sale::Quotation, foreign_key: :sale_quotation_id
  belongs_to :product_product, class_name: Product::Product, foreign_key: :product_product_id
  validates :quantity, :presence => {:message => "Debe ingresar una cantidad."}, :numericality => {:only_integer => true, :message => "La cantidad debe ser un número entero."}  
  def monto_pagar
    self.quantity * self.product_product.price
  end
end
