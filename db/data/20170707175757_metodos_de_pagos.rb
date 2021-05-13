class MetodosDePagos < SeedMigration::Migration
  def up
    [
      {name: "Transferencia electrónica"},
      {name: "Tarjeta de débito"},
      {name: "Tarjeta de crédito"},
      {name: "Pago en efectivo"}

    ].each do |metodo_pago|
      MethodPayment.create(metodo_pago)
    end
  end
  def down
    MethodPayment.destroy_all
  end
end
