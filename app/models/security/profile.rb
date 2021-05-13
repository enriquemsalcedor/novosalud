class Security::Profile < ApplicationRecord 
  belongs_to :security_role, class_name: Security::Role, foreign_key: :security_role_id
  has_many :employee, class_name: Employee, foreign_key: :security_profiles_id

 
	aasm column: "status"  do 
    state  :Activo, initial: true
    state  :Inactivo

    event :habilitar do
      transitions from: :Inactivo, to: :Activo
    end

    event :inhabilitar do
      transitions from: :Activo, to: :Inactivo,
                  after: [
                  :registrar_motivo
                  ]
    end
  end

  attr_accessor :motive, :user

  def registrar_motivo
    registrar_motivo = MotiveProfile.new
    registrar_motivo.user_created_id = self.user
    registrar_motivo.motive = self.motive
    registrar_motivo.profile_id = self.id
    registrar_motivo.status = "Inactivo"
    registrar_motivo.save
  end

  validates :name ,presence: true, uniqueness:{message:"Existe un registro con este nombre."}
  validates :security_role_id ,presence: true
  
  def self.search(search)
    where("name ILIKE ? OR cast(created_at as text) ILIKE ?" , "%#{search}%" , "%#{search}%")
  end
end
