class ResendUsernameMailer < ApplicationMailer
	def resend_username(employee)
		@employee = employee
    attachments.inline["novo_enlinea.png"] = File.read("#{Rails.root}/app/assets/images/novo_enlinea.png")
    mail to: @employee.email,subject: "Recuperación de usuario"
	end
end
