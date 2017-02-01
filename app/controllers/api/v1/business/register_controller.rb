class Api::V1::Business::RegisterController < ApplicationController

	def create
		user = User.new(user_params)
		user.password = SymmetricEncryption.encrypt params[:password]
		user.type_id = 1
		if user.save
			render :json => {model: user.email}
		else
			error = {code: 1}
			render :json => {model: error}, status: :bad_request
		end
	end

	def index
		en = SymmetricEncryption.encrypt "Sensitive data"
		de = SymmetricEncryption.decrypt en
		data = {en: en, de: de}
		render :json => {model: data}
	end

	private

	def user_params
		params.permit(:email, :address_description, :address_latitude, :address_longitude)
	end

end