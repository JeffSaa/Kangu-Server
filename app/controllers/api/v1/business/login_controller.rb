class Api::V1::Business::LoginController < ApplicationController

	def create
		password = SymmetricEncryption.encrypt params[:password]
		user = User.find_by(email: params[:email], password: password)
		if user
			if user.active
				if user.type_id == 5
					token = Token.new(user_id: user.id)
					if token.save
						render :json => {token: token.id, user_name: user.name, user_lastname: user.lastname,
							user_email: user.email, type: 5 }, status: :ok
					else
						error = {code: 5}
						render :json => error, status: :bad_request
					end
				else
					error = {code: 4}
					render :json => error, status: :unauthorized
				end
			else
				error = {code: 3}
				render :json => error, status: :unauthorized
			end
		else
			error = {code: 2}
			render :json => error, status: :not_found
		end
	end

end