class AddCompanyType < SeedMigration::Migration
  def up
 		[
      {name: "PYME", limit: 200 },
		  {name: "Corporativa", limit: 1500}
	  ].each do |company|
      Business::CompanyType.create(company)
    end  
  end

  def down
		Business::CompanyType.destroy_all
  end
end
