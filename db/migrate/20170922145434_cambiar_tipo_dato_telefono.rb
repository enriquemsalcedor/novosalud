class CambiarTipoDatoTelefono < ActiveRecord::Migration[5.0]
	def up
		change_table :people do |p|
			p.change :phone, :string
		end
	end

	def down
		change_table :people do |p|
			p.change :phone, :integer
		end
	end
end
