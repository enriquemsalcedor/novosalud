class Position < ApplicationRecord
  validates :name ,:presence =>{:message =>"Debe ingresar un nombre."},
  :uniqueness => {:message => "Existe un registro con este nombre."} ,
  length: { minimum: 3, maximum: 50 }

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

  def self.search(search)
    where("name ILIKE ?" , "%#{search}%")
  end
end
