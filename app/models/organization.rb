class Organization < ApplicationRecord
	validates :name, :presence => true
	validates :rif, :presence => true
	# validates :email, :presence => true , 
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i , :presence => true
	validates :address, :presence => true
	validates :phone, :presence => true
	#validates :days_validity, :presence => true , numericality: { only_integer: true }
	#validates :max_refech_service, :presence => true , numericality: { only_integer: true }

	scope :unico, ->{ where(id: 1)}

end
