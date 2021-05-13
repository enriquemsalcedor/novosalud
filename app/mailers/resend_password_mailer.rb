class ResendPasswordMailer < ApplicationMailer
	def resend_password(user)
		@user = user
		@mail = InitialValue.find(1)
    attachments.inline["novo_enlinea.png"] = File.read("#{Rails.root}/app/assets/images/novo_enlinea.png")
    mail to: @mail.email_security,subject: "Solicitud de recuperación de contraseña por parte de #{@user.email}"
	end
end
