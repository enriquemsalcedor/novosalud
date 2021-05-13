class Motive < ApplicationRecord
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

	validates :name , presence: true, uniqueness: true , length: { minimum: 3, maximum: 50 }

  def name=(s)
    write_attribute(:name, s.to_s.capitalize) 
  end

  # metodo de busqueda por criterio
	# parametro (search)
	def self.search(search)
		where("name ILIKE ?" , "%#{search}%")
	end
end
