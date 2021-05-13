class Colection::PackageProduct < ApplicationRecord
  belongs_to :product_products, class_name: Product::Product, foreign_key: :product_product_id
  belongs_to :colection_package, class_name: Colection::Package, foreign_key: :colection_package_id

  validates :product_product_id , presence: {:message =>"Debe seleccionar un proveedor."}
  validates_numericality_of :quantity, presence: {:message =>"Debe ingresar una cantidad."},:only_integer => true, 
    :greater_than_or_equal_to => 1
end
