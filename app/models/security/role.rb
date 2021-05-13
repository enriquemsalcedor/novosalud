class Security::Role < ApplicationRecord
  has_one :security_profile, class_name: Security::Profile, foreign_key: :security_profile_id

  has_many :security_role_types, :through => :security_role_profiles, class_name: Security::RoleType

  has_many :security_role_menus, class_name: Security::RoleMenu, foreign_key: :security_role_id
  has_many :security_menus , :through => :security_role_menus , class_name: Security::Menu, foreign_key: :security_menu_id

  aasm column: "status"  do
    state  :Activo, initial: true
    state  :Inactivo

    event :habilitar do
      transitions from: :Inactivo, to: :Activo
    end

    event :inhabilitar do
      transitions from: :Activo, to: :Inactivo
    end
  end

  validates :name ,presence: true, uniqueness: true

   #Guarda el nombre con la primera letra de cada palabra en mayuscula
  def name=(s)
    write_attribute(:name, s.to_s.titleize)
  end

  def self.search(search)
    where("name ILIKE ? OR cast(created_at as text) ILIKE ?" , "%#{search}%" , "%#{search}%")
  end

  def usuario(user)
    unless user.nil?
      @user = User.find(user)
      return @user.username
    end
  end
end
