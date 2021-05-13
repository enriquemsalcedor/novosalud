class AddInitialValues < SeedMigration::Migration
  def up
  	 [
  		{
  			days_validity: 2,
  			max_refech_service: 2,
  			number_employee: 50,
  			max_quantity_product: 100,
        email_max_quantity: 'admin@admin.com',
        email_security: 'jesuscardenasb85@gmail.com',
        days_validity_service: 15
  		}
    ].each do |value|
    	InitialValue.create(value)
    end
  end

  def down
  	InitialValue.destroy.all
  end
end
