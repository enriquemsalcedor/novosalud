# Preview all emails at http://localhost:3000/rails/mailers/certificate_product_mailer
class CertificateProductMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/certificate_product_mailer/enviar_certificado
  def enviar_certificado
    CertificateProductMailer.enviar_certificado
  end

end
