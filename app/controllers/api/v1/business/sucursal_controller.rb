class Api::V1::Business::SucursalController < ApplicationController

	def create
		token = Token.find_by(id: params[:token])
		if token
			user = User.find_by(id: token.user_id)
			if user
				type = UserType.find_by(id: user.type_id)
				if type.can_create_business_sucursal
					sucursal = BusinessSucursal.new(business_params)
					if sucursal.save
						render :json => {model: sucursal}, status: :ok
					else
						error = {code: 12}
						render :json => {model: error}, status: :bad_request
					end
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
		params.permit(:business_id, :name)
	end

end