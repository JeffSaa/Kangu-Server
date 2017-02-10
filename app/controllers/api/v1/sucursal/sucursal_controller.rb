class Api::V1::Sucursal::SucursalController < ApplicationController
	before_action :validate_authentification_token, :except => [:get_user_request]

	def create
		if @token
			if @user
				if @user.type_id == 301
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
			end
		end
	end

	def get_user_request
		requests = User.where(active: false, sucursal_id: params[:sucursal_id])
		render :json => requests, status: :ok
	end

	private

	def business_params
		params.permit(:business_id, :name, :phone, :address_description, :address_longitude, :address_latitude)
	end

end