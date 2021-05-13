class AddSecurityProfiles < SeedMigration::Migration
  
  def up
  	[
	  	{name: "Administrador",security_role_id: 5 },
	  	{name: "Analista",security_role_id: 1 },
	  	{name: "Supervisor",security_role_id: 1 },
	  	{name: "Gerente",security_role_id: 1 }
	  ].each do |security_profile|
	  	 Security::Profile.create(security_profile)
	  	end
	end

	def down
  Security::Profile.destroy.all
  end
end

