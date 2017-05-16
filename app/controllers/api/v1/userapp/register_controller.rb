class Api::V1::Userapp::RegisterController < ApplicationController
	before_action :validate_token

	def register
		user = User.new(user_params)
		user.password = SymmetricEncryption.encrypt params[:password]
		user.downcase_fields
		if @token_validation
			user.active = true
		end
		if user
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

	def send_confirmation_mail(user)
		RegisterMailer.confirm_account(user).deliver_later
	end

	def create_charge(user)
		charge = nil
		return charge
	end

	def user_params
		params.permit(:email, :address_description, :address_latitude, :address_longitude, :name, :lastname, :phone)
	end

end