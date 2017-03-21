class RegisterMailer < ApplicationMailer

	def confirm_account(user)
		@user = user
		mail(to: @user.email, subject: "Confirma tu cuenta Frepi!")
	end

end