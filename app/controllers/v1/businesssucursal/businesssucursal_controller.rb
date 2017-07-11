class V1::Businesssucursal::BusinesssucursalController < ApplicationController
	before_action :validate_authentification_token

	def create
		sucursal = BusinessSucursal.new(sucursal_params)
		sucursal.downcase_fields
		if sucursal.save
			user = getPlaceOwner(params[:business_id])
			params[:user_id] = user.id
			params[:target_id] = sucursal.id
			params[:type_id] = Constants::BUSINESS_ADMIN
			charge = create_charge()
			if charge.save
				render :json => {sucursal: sucursal, charge: charge}, status: :ok
			end
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

	def admins
		render :json => {model: getSucursalAdmins(params[:id])}, status: :ok
	end

	private

	def sucursal_params
		params.permit(:name, :business_id, :phone, :address_description, :addres_latitude, :address_logintude)
	end

end