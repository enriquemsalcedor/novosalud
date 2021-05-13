class Security::RoleProfile < ApplicationRecord
  belongs_to :security_profile, class_name: Security::Profile, foreign_key: :security_profile_id
  belongs_to :security_role, class_name: Security::Role, foreign_key: :security_role_id
  belongs_to :security_role_type, class_name: Security::RoleType, foreign_key: :security_role_type_id
  
  validates :security_role_id, :presence =>{:message => "No dejar campos vacios"}
  validates :security_role_type_id , :presence =>{:message => "No dejar campos vacios"} , 
             uniqueness: {scope: [:security_profile, :security_role_id ], message: "Este perfil ya tiene un rol de este tipo." }
  validates_datetime :end_date, :after => :publication_date, :start_date => "La fecha de inicio debe ser mayor a la fecha final"           






end
