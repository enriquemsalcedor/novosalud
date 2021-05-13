class ContactMailer < ApplicationMailer
  def send_contact_form(contact)
    @contact = contact
    @mail = InitialValue.find(1)
    attachments.inline["novo_enlinea.png"] = File.read("#{Rails.root}/app/assets/images/novo_enlinea.png")
    mail to: @mail.email_max_quantity,
    subject: 'Contacto o sugerencia'
  end
end
