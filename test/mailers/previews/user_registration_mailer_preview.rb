# Preview all emails at http://localhost:3000/rails/mailers/user_registration_mailer
class UserRegistrationMailerPreview < ActionMailer::Preview
	def confirmation_email
    UserRegistrationMailer.confirmation_email Customer.new()
  end
end

