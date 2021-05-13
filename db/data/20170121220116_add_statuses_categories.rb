class AddStatusesCategories < SeedMigration::Migration
	def up
		[
  	  {name: "Disponible", category_id: 1},
  	  {name: "Inactivo", category_id: 1 }
    ].each do |status|
      Status.create(status)
    end

    puts "Created #{Status.count} Statuses"

  end

  def down
  	Status.destroy_all
  end
end
