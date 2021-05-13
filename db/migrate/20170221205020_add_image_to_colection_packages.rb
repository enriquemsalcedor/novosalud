class AddImageToColectionPackages < ActiveRecord::Migration[5.0]
	def change
		add_attachment :colection_packages, :image
	end
end
