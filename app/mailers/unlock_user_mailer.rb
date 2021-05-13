class  UnlockUserMailer < ApplicationMailer
	def unlock_email(user)
		@user = user
		@mail = InitialValue.find(1)
    attachments.inline["novo_enlinea.png"] = File.read("#{Rails.root}/app/assets/images/novo_enlinea.png")
    mail to: @mail.email_security,subject: "Solicitud de desbloqueo de cuenta por parte de #{@user.email}"
	end
end

