class Api::V1::Business::LoginController < ApplicationController

	def create
		password = SymmetricEncryption.encrypt params[:password]
		user = User.find_by(email: params[:email], password: password)
		if user
			type = UserType.find_by(id: user.type_id)
			if type.can_login_app_business
				token = Token.new(user_id: user.id)
				if token.save
					render :json => { model: token.id }, status: :ok
				else
					render :json => {model: "Ups..."}, status: :bad_request
				end
			else
				render :json => {model: "Ups..."}, status: :unauthorized
			end
		else
			render :json => {model: "User not found"}, status: :not_found
		end
	end

	private

	def user_params
		params.permit(:email, :password)
	end

end