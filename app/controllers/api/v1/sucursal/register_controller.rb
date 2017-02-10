class Api::V1::Sucursal::RegisterController < ApplicationController

	def create
		business = BusinessPlace.find_by(domain: params[:domain])
		if business
			user = User.new(register_params)
			user.password = SymmetricEncryption.encrypt params[:password]
			if user.save
				render :json => {email: user.email}
			else
				error = {code: 17}
				render :json => error, status: :bad_request
			end
		else
			error = {code: 16}
			render :json => error, status: :bad_request
		end
	end

	private

	def register_params
		params.permit(:name, :email, :name, :lastname, :sucursal_id)
	end

end