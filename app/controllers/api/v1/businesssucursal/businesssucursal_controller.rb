class Api::V1::Businesssucursal::BusinesssucursalController < ApplicationController
	before_action :validate_authentification_token

	def create
		sucursal = BusinessSucursal.new(sucursal_params)
		sucursal.downcase_fields
		charge = create_charge();
		charge.type_id = Constants::BUSINESS_ADMIN
		if not charge_exist(@current_user, Constants::FREPI_ADMIN)
			charge.user_id = @current_user.id
		end
		if sucursal.save and charge.save
			render :json => {sucursal: sucursal, charge: charge}, status: :ok
		end
	end

	def search
		response = []
		if params[:search].length > 0
			response = BusinessSucursal.where('name LIKE ? OR address_description LIKE ?',
			"%#{params[:search]}%", "%#{params[:search]}%")
		end
		render :json => response, status: :ok
	end

	private

	def sucursal_params
		params.permit(:name, :business_id, :phone, :address_description, :addres_latitude, :address_logintude)
	end

end