class Api::V1::Sucursal::RegisterController < ApplicationController

	def create
		business = BusinessPlace.find_by(domain: params[:domain])
		if business
			user = User.new(register_params)
			user.email = params[:email]+"@"+params[:domain]
			user.password = SymmetricEncryption.encrypt params[:password]
			if user
				render :json => {model: user}
			else
				error = {code: 15}
				render :json => {model: error}, status: :bad_request
			end
		else
			error = {code: 14}
			render :json => {model: error}, status: :bad_request
		end
	end

	private

	def register_params
		params.permit(:name, :lastname)
	end

end