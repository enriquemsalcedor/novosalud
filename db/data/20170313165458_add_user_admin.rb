class AddUserAdmin < SeedMigration::Migration
  def up
  	People.create!([{
      first_name: 'admin',
      surname: 'Admin',
      type_identification: 'V' ,
      identification_document: "111111",
      email: 'admin@admin.com' ,
      date_birth: DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M"),
      sex: 'Masculino',
      phone: 02512222222,
      cellphone: 041222222222,
      address: 'Barquisimeto',
      territory_country_id: 227,
      territory_state_id: 12,
      territory_city_id: 190
    }])

    people = People.find_by identification_document: "111111"

    Position.create! ([{
      name: "Administrador"
      }])

    position = Position.last

    Employee.create! ([{
      first_name: 'admin',
      surname: 'Admin',
      type_identification: 'V' ,
      identification_document: "111111",
      second_name: 'admin',
      second_surname: 'admin',
      code_employee: 1,
      position: position,
      security_profiles_id: 1,
      status: 'Activo',
      email: 'admin@admin.com'
      }])

    user = User.last
    user.skip_confirmation!
    user.password = 'Admin123.'
    user.save
    user.update(password: 'Admin123.')
  end

  def down
  	User.destroy_all
  	People.destroy_all
  	Employee.destroy_all
  end
end
