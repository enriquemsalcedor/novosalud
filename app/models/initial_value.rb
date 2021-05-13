class InitialValue < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :days_validity,:number_employee,:max_quantity_product,:max_refech_service,:days_validity_service, :presence => true , numericality: { only_integer: true, greater_than_or_equal_to: 0} 
  validates :email_max_quantity, format: { :with => VALID_EMAIL_REGEX , message: "El formato del correo electrónico es inválido." } , :presence =>{:message =>"Debe ingresar un correo electrónico."}, length: { maximum: 50 }
end
