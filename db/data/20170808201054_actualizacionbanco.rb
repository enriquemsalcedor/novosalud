class Actualizacionbanco < SeedMigration::Migration
  def up
  	@cuenta_bancario = Account.all

		@cuenta_bancario.each do |cuenta_bancario|
      cuenta_bancario.update(email:"administracion@novosalud.com.ve")
    end
  end

  def down

  end
end
