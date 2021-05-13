class CambioPymes < SeedMigration::Migration
  def up
    @company_type = Business::CompanyType.find_by(name: "Pyme")

    @company_type.update(name: "Pymes")
  end

  def down
    @company_type = Business::CompanyType.find_by(name: "Pymes")

    @company_type.update(name: "Pyme")
  end
end
