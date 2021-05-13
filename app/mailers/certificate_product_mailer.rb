class CertificateProductMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.certificate_product_mailer.enviar_certificado.subject
  #
  def enviar_certificado(payment_contracted_products)
    @payment_contracted_products = payment_contracted_products
    @people = @payment_contracted_products[0].cliente
    attachments.inline["novo_enlinea.png"] = File.read("#{Rails.root}/app/assets/images/novo_enlinea.png")
    mail to: @people.email,
    subject: "Activación de producto"
  end
end
