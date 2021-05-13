class EditDescription < SeedMigration::Migration
  def up
    Security::Menu.where(description: "Tipo de producto</a>").update(description: "Tipo de producto")
  end

  def down
    Security::Menu.where(description: "Tipo de producto").update(description: "Tipo de producto</a>")
  end
end
