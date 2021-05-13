# Preview all emails at http://localhost:3000/rails/mailers/activacion_producto_mailer
class ActivacionProductoMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/activacion_producto_mailer/notificarActivacion
  def notificarActivacion
    ActivacionProductoMailer.notificarActivacion People.new()
  end

end
