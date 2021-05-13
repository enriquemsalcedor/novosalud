class AddQuotation < SeedMigration::Migration
  def up
		People.create!([{
      first_name: 'Lilandra',
      surname: 'Mckran',
      type_identification: 'V' ,
      identification_document: 19090909,
      email: 'lilandra@gmail.com' ,
      date_birth: DateTime.strptime("09/14/2000 8:00", "%m/%d/%Y %H:%M"),
      sex: 'Femenino',
      phone: 02512222222,
      cellphone: 041222222222,
      address: 'Barquisimeto',
      territory_country_id: 227,
      territory_state_id: 12,
      territory_city_id: 190
    }])

   	people = People.find_by identification_document: 19090909

   	Customer.create! ([{
	   	people_id: people.id,
	   	status: 'Activo'
	  }])

    user = User.last
    user.skip_confirmation!
    user.save


  	Sale::Quotation.create!([{
  		status:'Vigente',
  		user_id: user.id,
  		valid_since: DateTime.strptime("03/21/2017 8:00", "%m/%d/%Y %H:%M"),
  		valid_until: DateTime.strptime("03/23/2017 8:00", "%m/%d/%Y %H:%M")
      }])
    
  	Sale::ProductQuotation.create!([{
  		product_product_id: 1,
  		sale_quotation_id: 1,
  		quantity: 3
  		}])
  	Sale::PackageQuotation.create!([{
  		colection_package_id: 1,
  		sale_quotation_id: 1,
  		quantity: 2
  		}])
  end

  def down
  	People.destroy_all
  	User.destroy_all
  	Customer.destroy_all
		Sale::Quotation.destroy_all
		Sale::ProductQuotation.destroy_all
		Sale::PackageQuotation.destroy_all
  end
end
