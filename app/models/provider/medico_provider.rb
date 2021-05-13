class Provider::MedicoProvider < ApplicationRecord
  belongs_to :provider_provider, class_name: Provider::Provider, foreign_key: :provider_provider_id

  belongs_to :provider_medico, class_name: Provider::Medico, foreign_key: :provider_medico_id

  validates :provider_provider_id, :presence =>{:message => "Debe seleccionar un proveedor."},
   :uniqueness => {:scope => :provider_medico, :message => "Proveedor ya seleccionado."}

   def buscar_nombre_medico
     "#{self.provider_medico.people.first_name}"
   end

   def nombre_medico_completo
     "#{self.provider_medico.people.first_name} #{self.provider_medico.people.surname}"
   end
 end
