class DatosBancarios < SeedMigration::Migration
  def up
    Bank.create!([{name: "Banco Provincial" , direction_web:"https://www.provincial.com"}])
    banco = Bank.last
    Account.create!([
      {bank_id: banco.id, account_number: "01080947910100022205", account_type: "Corriente", email:"administracion@novosalud.com.ve"}
        ])

    Bank.create!([{name: "Banco Nacional de Crédito" , direction_web:"https://www.bnc.com.ve"}])
    banco = Bank.last
    Account.create!([
      {bank_id: banco.id, account_number: "01910060032160075389", account_type: "Corriente", email:"administracion@novosalud.com.ve"}
      ])

    Bank.create!([{name: "Banplus" , direction_web:"https://www.banplus.com"}])
    banco = Bank.last
    Account.create!([
      {bank_id: banco.id, account_number: "01740142491424150173", account_type: "Corriente", email:"administracion@novosalud.com.ve"}
      ])

    @bank = Bank.find_by(name: "Banco Exterior")
    if @bank.nil?
      Bank.create!([{name: "Banco Exterior" , direction_web:"https://www.bancoexterior.com"}])
      banco = Bank.last
      Account.create!([
        {bank_id: banco.id, account_number: "01150036661002524520", account_type: "Corriente", email:"administracion@novosalud.com.ve"}
        ])
    else
      Bank.update(direction_web:"https://www.bancoexterior.com")
      banco = Bank.last
      Account.create!([
        {bank_id: banco.id, account_number: "01150036661002524520", account_type: "Corriente", email:"administracion@novosalud.com.ve"}
        ])
    end
    
  end

  def down
    Bank.destroy_all
    Account.destroy_all
  end
end
