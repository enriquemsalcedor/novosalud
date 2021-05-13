class Business::CompanyType < ApplicationRecord
	validates :name ,:presence =>{:message =>"Debe ingresar un nombre."},
  :uniqueness => {:message => "Existe un registro con este nombre."}
  validates :limit, :presence => {:message => "Debe ingresar el limite de empleados"}, 
  numericality: { only_integer: true }
  
	aasm column: "status"  do 
    state  :Activo, initial: true
    state  :Inactivo

  event :habilitar do
      transitions from: :Inactivo, to: :Activo
    end

    event :inhabilitar do
      transitions from: :Activo, to: :Inactivo
    end
  end

   #Guarda el nombre con la primera letra de cada palabra en mayuscula
  def name=(s)
    write_attribute(:name, s.to_s.titleize)
  end
end
