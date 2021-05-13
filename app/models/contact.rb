class Contact < ApplicationRecord
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :name, :presence =>{:message =>"Debe ingresar su nombre y apellido."}, length: { maximum: 50 }
	validates :email, format: { :with => VALID_EMAIL_REGEX , message: "El formato del correo electrónico es inválido." } , :presence =>{:message =>"Debe ingresar un correo electrónico."}, length: { maximum: 50 }
	validates :subject, :presence =>{:message =>"Debe ingresar un asunto."}, length: { maximum: 50 }
	validates :message, :presence =>{:message =>"Debe escribir un mensaje"}, length: { maximum: 200 }
end
