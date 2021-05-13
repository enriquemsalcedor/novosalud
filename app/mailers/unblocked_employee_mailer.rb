class UnblockedEmployeeMailer < ApplicationMailer
	def unblocked_employee(employee)
		@employee = employee
    attachments.inline["novo_enlinea.png"] = File.read("#{Rails.root}/app/assets/images/novo_enlinea.png")
    mail to: @employee.email,subject: "Desbloqueo de cuenta"
	end
end
