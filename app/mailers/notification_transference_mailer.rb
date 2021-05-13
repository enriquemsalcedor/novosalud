class NotificationTransferenceMailer < ApplicationMailer

  def notificacion_transferencia(payment_transference)
    @novosalud = InitialValue.find_by(:id => 1)
    @transfe = [@novosalud.administration_email, @novosalud.call_center_email]
    @payment_transference = payment_transference
    attachments.inline["novo_enlinea.png"] = File.read("#{Rails.root}/app/assets/images/novo_enlinea.png")
    mail to: @transfe,
    subject: "Transferencia Bancaria"
  end

end

