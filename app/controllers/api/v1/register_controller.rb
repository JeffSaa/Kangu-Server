class Api::V1::RegisterController < ApplicationController

	def create
		user = User.new(user_params)
		user.password = SymmetricEncryption.encrypt params[:password]
		render :json => {model: user}
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