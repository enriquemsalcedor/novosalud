class AddEmailsInitialValues < SeedMigration::Migration
  def up
 		InitialValue.where(id: 1).update(administration_email:'administracion@novosalud.com.ve',call_center_email: 'maria.oropeza@novosalud.com.ve')
  end

  def down
  	InitialValue.destroy.all
  end
end
