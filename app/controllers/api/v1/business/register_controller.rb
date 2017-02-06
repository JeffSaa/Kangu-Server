class Api::V1::Business::RegisterController < ApplicationController

	def create
		user = User.new(user_params)
		user.password = SymmetricEncryption.encrypt params[:password]
		user.type_id = 6
		if user.save
			render :json => {model: user.email, type: 6}
		else
			error = {code: 1}
			render :json => error, status: :bad_request
		end
	end

	private

	def user_params
		params.permit(:email, :address_description, :address_latitude, :address_longitude)
	end

end