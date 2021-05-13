class Provider::Medico < ApplicationRecord
  belongs_to :people, class_name: People,
  foreign_key: :people_id, dependent: :destroy, :autosave => true
  belongs_to :speciality  
  accepts_nested_attributes_for :people, :allow_destroy => true, :reject_if => :all_blank
  validates_associated  :people
  
  has_many :provider_medico_providers, class_name: Provider::MedicoProvider , foreign_key: :provider_provider_id #, foreign_key: :provider_medico_id
  has_many :provider_providers, through: :provider_medico_providers,class_name: Provider::Provider#, foreign_key: :provider_provider_id
  
  validates :phone_medico, :presence =>{:message =>"Debe colocar un número teléfonico."}, numericality: { only_integer: true,:message => "Sólo se permiten caracteres numéricos." }

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

  def name=(s)
    write_attribute(:name, s.to_s.titleize)
  end

  # metodo de busqueda por criterio
  # parametro (search)
  def self.search(search) 
    joins(:people).
    joins( 'INNER JOIN "provider_medico_providers" ON "provider_medico_providers"."provider_medico_id" = "provider_medicos"."id" 
    INNER JOIN "provider_providers" ON "provider_providers"."id" = "provider_medico_providers"."provider_provider_id" ' ).
    where(' "provider_medicos"."code_medico" ILIKE ? OR lower("people"."first_name") ILIKE ?
    OR lower("people"."surname") ILIKE ? OR cast("people"."identification_document" as text) ILIKE ? OR lower("people"."email") ILIKE ?
    OR lower("people"."phone") ILIKE ? OR lower("people"."cellphone") ILIKE ? OR "provider_providers"."name" ILIKE ?' , 
      "%#{search}%" , "%#{search}%" , "%#{search}%" , "%#{search}%" , "%#{search}%",
      "%#{search}%" , "%#{search}%" , "%#{search}%"  )
  end
  
  #Metodo para verificar si el empleado que  va registar el medico es externo o interno.
  def verificar_empleado_externo?(user)
    unless user.nil?
      @employee = Employee.find_by(user_id: user)
      unless @employee.nil?
        puts user
        puts @employee.provider_provider_id.nil? 
        @employee.provider_provider_id.nil?
      end
    end
  end

  def verificar_medico?(medico,user)
    @medico = Provider::Medico.find_by(people_id: medico.people.id)
    @employee = Employee.find_by(user_id: user)
    @provider = Provider::Provider.find(@employee.provider_provider_id)
    unless @medico.nil?
      @provider_medico_provider = Provider::MedicoProvider.find_by(provider_medico_id: @medico.id, provider_provider_id: @employee.provider_provider_id)
      if @provider_medico_provider.nil?
        @provider_medico_provider = Provider::MedicoProvider.new
        @provider_medico_provider.provider_provider_id = @provider.id
        @provider_medico_provider.provider_medico_id = @medico.id
        @provider_medico_provider.save!
      end
      @provider_medico_provider.nil?
    end    
  end

end

