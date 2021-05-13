class Beneficiary < ApplicationRecord
  belongs_to :people, class_name: People, foreign_key: :people_id, dependent: :destroy, :autosave => true
  accepts_nested_attributes_for :people, :allow_destroy => true, :reject_if => :all_blank
  validates_associated  :people

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

#Metodo para buscar el beneficiario 
def self.searchBeneficiary(searchBeneficiary,type_identification)
  people = People.where('"people"."identification_document" = ? AND "people"."type_identification" = ?',searchBeneficiary,type_identification).first  
  unless people.nil?
    beneficiary = Beneficiary.where(people_id: people.id).first
    unless beneficiary.nil?
      return beneficiary
    else
      beneficiary = Beneficiary.create(people_id: people.id)
      return beneficiary
    end
  else
    return nil
  end
end
def buscar_nombre_beneficiario
  "#{self.people.first_name} #{self.people.surname}"

end

def cedula_beneficiario
  "#{people.type_identification}-#{people.identification_document}"
end

def contacto
  unless self.people.phone.nil? 
    "#{self.people.phone}"
    unless self.people.cellphone.nil? 
      "#{self.people.phone} - #{self.people.cellphone}"
    end
  end 
end


def self.search(search)

  joins(:people).where(' lower("people"."first_name") ILIKE ? OR lower("people"."surname") ILIKE ? 
    OR cast("people"."identification_document" as text) ILIKE ?
    OR lower("people"."phone") ILIKE ? OR lower("people"."cellphone") ILIKE ? OR lower("people"."sex") ILIKE ? ' , 
    "%#{search}%" , "%#{search}%" , "%#{search}%" , "%#{search}%", "%#{search}%" , "%#{search}%")
end

end
