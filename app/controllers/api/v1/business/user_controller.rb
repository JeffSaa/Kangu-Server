class Api::V1::Business::UserController < ApplicationController

	def create
		user = User.new(user_params)
		user.password = SymmetricEncryption.encrypt params[:password]
		user.type_id = 301
		user.lowercase_fields
		if user.save
			render :json => {email: user.email, name: user.name, lastname: user.lastname, type: user.type_id}
		else
			error = {code: 1}
			render :json => error, status: :bad_request
		end
	end

	private

	def user_params
		params.permit(:email, :address_description, :address_latitude, :address_longitude, :name, :lastname)
	end

end