class AddQuotationTest < SeedMigration::Migration
def up
		People.create!([{
      first_name: 'Toshiro',
      surname: 'Sama',
      type_identification: 'V' ,
      identification_document: 1000009,
      email: 'toshiro@gmail.com' ,
      date_birth: DateTime.strptime("05/14/1999 8:00", "%m/%d/%Y %H:%M"),
      sex: 'Masculino',
      phone: 02512222222,
      cellphone: 041222222222,
      address: 'Barquisimeto',
      territory_country_id: 227,
      territory_state_id: 12,
      territory_city_id: 190
    }])

   	people = People.find_by identification_document: 1000009

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
  		sale_quotation_id: 2,
  		quantity: 5
  		}],)
  	Sale::PackageQuotation.create!([{
  		colection_package_id: 1,
  		sale_quotation_id: 2,
  		quantity: 3
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

