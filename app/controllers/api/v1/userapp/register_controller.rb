class Api::V1::Userapp::RegisterController < ApplicationController

	def register
		user = User.new(user_params)
		user.password = SymmetricEncryption.encrypt params[:password]
		user.downcase_fields
		u = validate_token()
		if u and charge_exist(u, Constants::FREPI_ADMIN)
			user.active = true
		end
		if user.save
			render_user(user)
		else
			render_response_json(123, :bad_request)
		end
	end

	def confirmation_email
		user = User.find_by(uuid: params[:uuid])
		if user
			user.update(active: true)
		end
		render :json => user, status: :ok
	end

	private

	def user_params
		params.permit(:email, :address_description, :address_latitude, :address_longitude, :name, :lastname, :phone)
	end

end