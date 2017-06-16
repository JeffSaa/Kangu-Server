class Api::V1::Businessplace::BusinessplaceController < ApplicationController
	before_action :validate_authentification_token

	def index
		response = []
		places = BusinessPlace.all
		places.each do |p|
			response << {place: p, sucursals: BusinessSucursal.where(business_id: p.id)}
		end
		render :json => {model: response}, status: :ok
	end

	def create
		place = BusinessPlace.new(place_params)
		place.downcase_fields
		if place.save
			if params[:photo]
				upload_blob("businessplace", params[:photo], place.id)
			end
			charge = create_charge()
			charge.target_id = place.id
			charge.type_id = Constants::BUSINESS_OWNER
			if not charge_exist(@current_user, Constants::KANGU_ADMIN)
				charge.user_id = @current_user.id
			end
			if charge.save
				render :json => {charge: charge, businessplace: place}, status: :ok
			end
		end
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