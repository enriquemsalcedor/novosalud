class ChangeQuotationsMenu < SeedMigration::Migration
  def up
    @quotations = Security::RoleType.find_by(name: 'Pagar')
    @quotations.update(controller: nil, action: false)
  end

  def down
    @quotations = Security::RoleType.find_by(name: 'Pagar')
    @quotations.update(controller: 'sale/quotations', action: true)
  end
end
