class Api::V1::Business::SucursalController < ApplicationController
	before_action :validate_authentification_token

	def create
		if @token
			user = User.find_by(id: @token.user_id)
			if user
				if user.type_id < 6
					sucursal = BusinessSucursal.new(business_params)
					if sucursal.save
						render :json => {name: sucursal.name}, status: :ok
					else
						error = {code: 13}
						render :json => error, status: :bad_request
					end
				else
					error = {code: 12}
					render :json => error, status: :bad_request
				end
			else
				error = {code: 11}
				render :json => error, status: :bad_request
			end
		end
	end

	private

	def business_params
		params.permit(:business_id, :name)
	end

end