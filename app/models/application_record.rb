class ApplicationRecord < ActiveRecord::Base
	#se incluye la libreria de la gema AASM para que sea compartida entre todos los modelos
  include AASM
  self.abstract_class = true

  @organization = Organization.name
	
end


