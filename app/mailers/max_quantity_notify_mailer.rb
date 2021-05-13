class MaxQuantityNotifyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.max_quantity_notify_mailer.notify.subject
  #
  def notify(quotation,hash_producto)
    @quotation = quotation
    @hash_producto = hash_producto
    @product_quotations = @quotation.sale_product_quotations

    @mail = InitialValue.find(1)
    attachments.inline["novo_enlinea.png"] = File.read("#{Rails.root}/app/assets/images/novo_enlinea.png")
    mail to: @mail.email_max_quantity,
    subject: "Alerta en la cotización N-#{@quotation.quoting_number}"
  end
end
