class Payment::Transference < ApplicationRecord
  belongs_to :sale_quotations , class_name: Sale::Quotation, foreign_key: :sale_quotation_id
  belongs_to :bank , class_name: Bank, foreign_key: :bank_id

  after_create :enviar_notificacion

  # estilo para guardar la imagen con un tamaño fijo de 200x200
  has_attached_file :file
  # validacion para solo aceptar archivo de tipo imagen
  validates_attachment_content_type :file,  content_type: ["application/pdf","image/jpeg", "image/png", "image/gif"]

  validates :reference,  :presence =>{:message =>"Debe ingresar un número referencia."}
  validates :bank_id , :presence =>{:message =>"Debe seleccionar un banco."}
  
  def enviar_notificacion
    @payment_transference = self
    NotificationTransferenceMailer.notificacion_transferencia(@payment_transference).deliver_now
  end
end
