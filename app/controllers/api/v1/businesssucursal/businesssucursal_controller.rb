class Api::V1::Businesssucursal::BusinesssucursalController < ApplicationController
	before_action :validate_authentification_token

	def create
		if charge_exist(@current_user, Constants::FREPI_ADMIN) or charge_exist(@current_user, Constants::BUSINESS_OWNER)
			sucursal = BusinessSucursal.new(sucursal_params)
			sucursal.downcase_fields
			if sucursal.save
				render :json => sucursal, status: :ok
			end
		end
	end

	private

	def sucursal_params
		params.permit(:name, :business_id, :phone, :address_description, :addres_latitude, :address_logintude)
	end

end