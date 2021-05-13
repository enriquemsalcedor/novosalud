class AddTipoProveedor < SeedMigration::Migration
  def up
  	[
      {name: "Centro médico"},
		  {name: "Laboratorio"}

	  ].each do |proveedor|
      Provider::ProviderType.create(proveedor)
    end
    puts "Created #{Provider::ProviderType.count} Tipo:Proveedor"
  end
  def down
  	Provider::ProviderType.destroy_all
  end
end
