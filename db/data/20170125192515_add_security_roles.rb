class AddSecurityRoles < SeedMigration::Migration
 def up
  	[
	  	{name: "Caja"},
	 		{name: "Clínica"},
	  	{name: "Configurador"},
	  	{name: "Servicio"}, 
	  	{name: "Administrador"}
	  ].each do |security_role|
	  	 Security::Role.create(security_role)
	  	end
	end

	def down
  Security::Role.destroy.all
  end
end
