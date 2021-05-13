class Security::RoleMenu < ApplicationRecord
  belongs_to :security_role, class_name: Security::Role, foreign_key: :security_role_id
  belongs_to :security_menu, class_name: Security::Menu, foreign_key: :security_menu_id
  has_many :security_role_type_menus ,class_name: Security::RoleTypeMenu, foreign_key: :security_role_menu_id, dependent: :destroy
  has_many :security_role_types , :through => :security_role_type_menus , class_name: Security::RoleType, foreign_key: :security_role_type_id
  validates :security_menu_id, :presence =>{:message => "Este menú ya existe para este rol "} , :uniqueness => {:scope => :security_role}
end
