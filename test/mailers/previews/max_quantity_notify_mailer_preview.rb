# Preview all emails at http://localhost:3000/rails/mailers/max_quantity_notify_mailer
class MaxQuantityNotifyMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/max_quantity_notify_mailer/notify
  def notify
    MaxQuantityNotifyMailer.notify
  end

end
