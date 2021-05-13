# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/contact_mailer/send_contact_form
  def send_contact_form
    ContactMailer.send_contact_form Contact.new(name: 'Engelbert Freitez',email: 'efreitez.itecnologica@gmail.com', subject: 'Prueba', message: 'Correo de prueba')
  end

end
