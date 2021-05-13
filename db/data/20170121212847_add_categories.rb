class AddCategories < SeedMigration::Migration
  def up
    [
    {name: "Producto"},
    {name: "Paquete"},
    {name: "Producto_Cotizado"},
    {name: "Paquete_Cotizado"},
      {name: "Plan"},
      {name: "Paquete_Por_Cotizado"}
    ].each do |category|
      Category.create(category)
    end

    puts "Created #{Category.count} Categories"

  end

  def down
    Category.destroy_all
  end
end
