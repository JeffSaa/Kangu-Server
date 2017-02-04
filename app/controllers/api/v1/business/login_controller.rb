class Api::V1::Business::LoginController < ApplicationController

	def create
		password = SymmetricEncryption.encrypt params[:password]
		user = User.find_by(email: params[:email], password: password)
		if user
			if user.active
				type = UserType.find_by(id: user.type_id)
				if type.can_login_app_business
					token = Token.new(user_id: user.id)
					if token.save
						render :json => {model: token.id }, status: :ok
					else
						error = {code: 3}
						render :json => error, status: :bad_request
					end
				else
					error = {code: 4}
					render :json => error, status: :unauthorized
				end
			else
				error = {code: 13}
				render :json => error, status: :unauthorized
			end
		else
			error = {code: 2}
			render :json => error, status: :not_found
		end
	end

end