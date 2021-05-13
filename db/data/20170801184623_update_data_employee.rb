class UpdateDataEmployee < SeedMigration::Migration
  def up
    @employees = Employee.where('"employees"."code_employee" != ?',"1")

    @employees.each do |empleado|
      perfilanterior = empleado.security_profiles_id
      empleado.update(:previous_profile_security => perfilanterior, :type_profile => "Permanente")
    end
  end

  def down
    @employees = Employee.where('"employees"."code_employee" != ?',"1")

    @employees.each do |empleado|
      perfilanterior = empleado.security_profiles_id
      empleado.update(:previous_profile_security => nil, :type_profile => nil)
    end
  end
end
