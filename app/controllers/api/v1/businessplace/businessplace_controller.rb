class Api::V1::Businessplace::BusinessplaceController < ApplicationController
	before_action :validate_authentification_token

	def create
		place = BusinessPlace.new(place_params)
		place.downcase_fields
		if place.save
			upload_blob("businessplace", params[:photo], place.id)
			charge = create_charge()
			charge.target_id = place.id
			charge.type_id = Constants::BUSINESS_OWNER
			if not charge_exist(@current_user, Constants::FREPI_ADMIN)
				charge.user_id = @current_user.id
			end
			if charge.save
				render :json => {charge: charge, businessplace: place}, status: :ok
			end
		end
	end

	def get_admins
		render :json => {model: getPlaceAdmins(params[:id])}, status: :ok
	end

	def show
		response = {place: BusinessPlace.find(params[:id]), owner: getPlaceOwner(params[:id]), sucursal: BusinessSucursal.where(business_id:params[:id])}
		render :json => response, status: :ok
	end

	def search
		response = []
		if params[:search].length > 0
			response = BusinessPlace.where('name LIKE ?', "%#{params[:search]}%")
		end
		render :json => response, status: :ok
	end

	private

	def place_params
		params.permit(:name)
	end

end