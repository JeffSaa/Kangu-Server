class V1::Users::LoginController < ApplicationController

	def create
		password = SymmetricEncryption.encrypt params[:password]
		user = User.find_by(email: params[:email], password: password)
		if user
			if user.active
				token = Token.new(user_id: user.id)
				if token.save
					render_user(user, token.id)
				else
					render_response_json(4, :bad_request)
				end
			else
				render_response_json(3, :unauthorized)
			end
		else
			render_response_json(2, :not_found)
		end
	end

	private

end