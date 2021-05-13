class ActivacionProductoMailer < ApplicationMailer
  def notificarActivacion(people, service )
    @people = people
    @service_service = service
    @organization =Organization.find(1)
    attachments.inline["novo_enlinea.png"] = File.read("#{Rails.root}/app/assets/images/novo_enlinea.png")
    mail to: @people.email, subject: 'Activación de producto'
  end
end
