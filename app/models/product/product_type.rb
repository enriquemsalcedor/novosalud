class Product::ProductType < ApplicationRecord
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

	validates :name , presence: true, uniqueness: true

	scope :activos, ->{ where(status: "Activo")}

  def name=(s)
    write_attribute(:name, s.to_s.capitalize) 
  end

  # metodo de busqueda por criterio
	# parametro (search)
	def self.search(search)
		where("name ILIKE ? OR description ILIKE ?" , "%#{search}%" , "%#{search}%")
	end
end
