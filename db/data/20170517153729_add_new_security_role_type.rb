class AddNewSecurityRoleType < SeedMigration::Migration
  def up
  	[
  		{name: "Activar"},
      {name: "Anular",controller: "service/services", action: true},
      {name: "Reagendar",controller: "service/services", action: true},
      {name: "Cancelar",controller: "service/services", action: true},
      {name: "Atender",controller: "clinic/clinic_service", action: true},
      {name: "Pagar",controller: "sale/quotations", action: true}
    ].each do |security_role_type|
    	Security::RoleType.create(security_role_type)
    end
  end

  def down
	Security::RoleType.destroy.all
  end
end
