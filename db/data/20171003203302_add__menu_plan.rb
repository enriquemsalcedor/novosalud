class AddMenuPlan < SeedMigration::Migration
  def up
    @menu = Security::Menu.find_by(description: "Planes")

    @menu.update(description: 'Órdenes de compra', codemenu: '<a href="/payment/plans">Órdenes de compra</a>' )

  end

  def down

  end
end
