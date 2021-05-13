class MethodPayment < ApplicationRecord
  has_many :plans , class_name: Payment::Plan

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

  scope :activo, ->{ where(status: "Activo")}
  
   #Guarda el nombre con la primera letra de cada palabra en mayuscula
  def name=(s)
    write_attribute(:name, s.to_s.capitalize) 
  end

  validates :name ,presence: true, uniqueness: true

  # metodo de busqueda por criterio
  # parametro (search)
  def self.search(search)
    where("name ILIKE ? OR cast(created_at as text) ILIKE  ?" , "%#{search}%" , "%#{search}%")
  end
  #metodo que Cuenta los Planes Segun los metodos de pago
  def count_planes(fecha)
    @planes = Payment::Plan.where(method_payment_id: self.id).where("DATE(created_at) = ?", fecha)
    return @planes.count
  end
  #metodo que Suma los Planes Segun los metodos de pago
   def total_montos(fecha)
    acum = 0
    @lis_Planes = Payment::Plan.where(method_payment_id: self.id).where("DATE(created_at) = ?", fecha)
    @lis_Planes.each do |plan|
      acum = acum + plan.total_amount
    end
    return acum 
  end

end
