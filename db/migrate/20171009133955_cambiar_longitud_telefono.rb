class CambiarLongitudTelefono < ActiveRecord::Migration[5.0]
  def change
    change_table :provider_providers do |p|
      p.change :phone,:string , limit: 80
      p.change :phone2,:string , limit: 80
       p.change :phone3,:string , limit: 80
    end
  end
end
