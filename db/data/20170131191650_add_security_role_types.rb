class AddSecurityRoleTypes < SeedMigration::Migration
  def up
  	[
  		{name: "Crear"},
  		{name: "Consultar"},
  		{name: "Modificar"},
  		{name: "Eliminar"}

    ].each do |security_role_type|
    	Security::RoleType.create(security_role_type)
    end

  end

  def down
  	Security::RoleType.destroy.all
  end
end
