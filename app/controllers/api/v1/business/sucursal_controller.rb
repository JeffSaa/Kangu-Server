class Api::V1::Business::BusinessController < ApplicationController

	def create
		token = Token.find_by(id: params[:token])
		if token
			user = User.find_by(id: token.user_id)
			if user
				type = UserType.find_by(id: user.type_id)
				if type.can_create_business_sucursal

				else
					error = {code: 11}
					render :json => {model: error}, status: :unauthorized
				end
			else
				error = {code: 10}
				render :json => {model: error}, status: :unauthorized
			end
		else
			error = {code: 9}
			render :json => {model: error}, status: :unauthorized
		end
	end

	private

	def business_params
		params.permit(:business_id)
	end

end