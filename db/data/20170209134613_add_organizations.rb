class AddOrganizations < SeedMigration::Migration
  def up
  	[
  		{
  			name: "NovoSalud, Medicina Prepagada S.A.",
  			rif: "J-43230666-0",
  			email: "24horasnovosaludlara@gmail.com",
  			address: "Calle 26 entre 16 y 17, Edificio Centro Plaza, Piso PB, Local 03. Barquisimeto - Venezuela ",
  			phone: "+58 0251 250.44.50",
  			#days_validity: 2,
  			#max_refech_service: 2
  		}
    ].each do |organization|
    	Organization.create(organization)
    end

  end

  def down
  	Organization.destroy.all
  end
end
