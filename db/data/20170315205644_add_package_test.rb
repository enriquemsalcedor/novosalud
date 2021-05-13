class AddPackageTest < SeedMigration::Migration
  def up
    Speciality.create!([{
      name: 'Psiquiatria'
      }])
    Product::ProductType.create!([{
      name: 'Consulta'
      }])
    providertype = Provider::ProviderType.find_by name: 'Centro Médico'
    speciality = Speciality.find_by name: 'Psiquiatria'
    producttypes = Product::ProductType.find_by name: 'Consulta'

    Provider::Provider.create!([{
      name: 'Luis Gomez Lopez',
      type_identification: 'J',
      rif: '4545454545', 
      phone: '02512333333',
      email: 'lgl@prueba.com',
      address: 'Calle 12',
      territory_country_id: 227,
      territory_state_id: 12,
      territory_city_id: 190,
      provider_provider_type_id: providertype.id,
      type_identification_responsable: "v",
      identification_document: "17333444",
      firt_name_responsable: "Jose",
      last_name_responsable: "Perez",
      phone_responsable: "4545454544",
      position: "Administrador",
      email_responsable: "jose@gmail.com"

      }])

    provider = Provider::Provider.last

    Product::Product.create!([{
      name: 'Consulta Psiquiatrica',
      speciality_id: speciality.id,
      product_product_type_id: producttypes.id,
      category: 'PYMES',
      publication_date: DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M"),
      expiration_date: DateTime.strptime("10/14/2009 8:00", "%m/%d/%Y %H:%M"),
      provider_provider_id: provider.id,
      price: '3000',
      valid_days: 10
      }])

    products = Product::Product.last  
    Colection::Package.create!([{
      description: 'Combo 1',
      valid_since: DateTime.strptime("09/14/2009 8:00", "%m/%d/%Y %H:%M"),
      valid_until: DateTime.strptime("10/14/2009 8:00", "%m/%d/%Y %H:%M"),
      category: 'PYMES',
      total_amount: 50000
      }])

    paquete = Colection::Package.find_by description: 'Combo 1'

    Colection::PackageProduct.create!([{
      quantity: 2,
      colection_package_id: paquete.id,
      product_product_id: products.id
      }])

  end
  def down
    Speciality.destroy_all
    Product::ProductType.destroy_all
    Provider::Provider.destroy_all
    Product::Product.destroy_all
    Colection::Package.destroy_all
    Colection::PackageProduct.destroy_all
  end
end
