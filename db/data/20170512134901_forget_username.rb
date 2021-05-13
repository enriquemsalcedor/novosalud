class ForgetUsername < SeedMigration::Migration
  def up
  	menupadre = Security::Menu.find_by description: 'Registro'
    Security::Menu.create!([
      { description: 'Recuperar Usuario', codemenu: '<a href="/forget_username_list">Recuperar Usuario</a>', menu_id: menupadre.id },
      { description: 'Recuperar Contraseña', codemenu: '<a href="/forget_password">Recuperar contraseñas</a>', menu_id: menupadre.id }
    ])

  end

  def down
  	Security::Menu.destroy.all
  end
end
