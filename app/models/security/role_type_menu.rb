class Security::RoleTypeMenu < ApplicationRecord
  belongs_to :security_role_type, class_name: Security::RoleType, foreign_key: :security_role_type_id
  belongs_to :security_role_menu, class_name: Security::RoleMenu, foreign_key: :security_role_menu_id

  validates :security_role_type_id, :uniqueness => {:scope => :security_role_menu}
  
  attr_accessor :id_role, :id_menu
end
