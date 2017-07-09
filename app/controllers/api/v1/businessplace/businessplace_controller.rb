class Api::V1::Businessplace::BusinessplaceController < ApplicationController
	before_action :validate_authentification_token, :except => [:credit_status]

	def index
		response = []
		places = BusinessPlace.all
		places.each do |p|
			response << {place: p, sucursals: BusinessSucursal.where(business_id: p.id)}
		end
		render :json => {model: response}, status: :ok
	end

	def create
		chargeAdmin = charge_exist(@current_user, Constants::KANGU_ADMIN)
		if chargeAdmin
			place = BusinessPlace.new(kangu_admin_place_params)
		else
			place = BusinessPlace.new(place_params)
		end
		place.downcase_fields
		if place.save
			if params[:photo]
				upload_blob("businessplace", params[:photo], place.id)
			end
			charge = create_charge()
			charge.target_id = place.id
			charge.type_id = Constants::BUSINESS_OWNER
			if not chargeAdmin
				charge.user_id = @current_user.id
			end
			if charge.save
				render :json => {charge: charge, businessplace: place}, status: :ok
			end
		end
	end

	def update
		place = BusinessPlace.find(params[:id])
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			place.update(kangu_admin_place_params)
		else
			place.update(place_params)
		end
		render :json => place, status: :ok
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

	def credit_status
		place = BusinessPlace.find_by(uid: params[:uid])
		response = {place: place, total_expired: 0, orders: []}
		BusinessSucursal.where(business_id: place.id).each do |b|
			Order.where(order_type: 0, target_id: b.id, pay_mode: Constants::PAY_MODE_CREDIT_BUSINESS, is_payed: false). each do |o|
				if o.interest_count > 0
					response[:total_expired] += o.total * Constants::CREDIT_INTEREST_PERCENT / 100 * interest_count + o.total
				end
				response[:orders] << {sucursal: b, order: o}
			end
		end
		render :json => response, status: :ok
	end

	private

	def place_params
		params.permit(:name)
	end

	def kangu_admin_place_params
		params.permit(:name, :credit_term, :credit_fit, :current_deb, :credit_active)
	end

end