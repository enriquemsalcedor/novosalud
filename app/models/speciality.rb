class Speciality < ApplicationRecord
  has_many :product_products

  aasm column: "status" do
    state :Activo, initial: true
    state :Inactivo

    event :inhabilitar do
      transitions from: :Activo, to: :Inactivo
    end

    event :habilitar do
      transitions from: :Inactivo, to: :Activo
    end
  end

  validates :name, :presence =>{:message =>"Debe ingresar un nombre."}
  validates :name, :uniqueness => {:message => "Existe un registro con este nombre."}
  validates :name, length: { minimum: 3, maximum: 50 }

  def name=(s)
    write_attribute(:name, s.to_s)
  end

  scope :activos, ->{ where(status: "Activo")}

  # metodo de busqueda por criterio
  # parametro (search)
  def self.search(search)
    where("name ILIKE ? OR description ILIKE ?" , "%#{search}%" , "%#{search}%")
  end

end

