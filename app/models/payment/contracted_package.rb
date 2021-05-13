class Payment::ContractedPackage < ApplicationRecord
	belongs_to :plan , class_name: Payment::Plan,foreign_key: :plan_id 
  belongs_to :colection_package , class_name: Colection::Package,foreign_key: :colection_package_id 
  has_many :payment_contracted_products , class_name: Payment::ContractedPackage
end
