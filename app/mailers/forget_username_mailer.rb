class ForgetUsernameMailer < ApplicationMailer
	def forget_username(user)
		@user = user
		@mail = InitialValue.find(1)
    attachments.inline["novo_enlinea.png"] = File.read("#{Rails.root}/app/assets/images/novo_enlinea.png")
    mail to: @mail.email_security,subject: "Solicitud de recuperación de usuario por parte de #{@user.email}"
	end
end
