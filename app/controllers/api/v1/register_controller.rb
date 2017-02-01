class Api::V1::RegisterController < ApplicationController

	def create
		user = User.new(user_params)
		user.password = SymmetricEncryption.encrypt params[:password]
		if user.save
			render :json => {model: user}
		else
			render :json => {model: "Ups..."}, status: :not_found
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