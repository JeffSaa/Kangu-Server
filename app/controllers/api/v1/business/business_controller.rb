class Api::V1::Business::BusinessController < ApplicationController

	def index
		en = SymmetricEncryption.encrypt "Sensitive data"
		de = SymmetricEncryption.decrypt en
		data = {en: en, de: de}
		render :json => {model: data}
	end

	def create
		token = Token.find_by(id: params[:token])
		if token
			user = User.find_by(id: token.user_id)
			if user
				type = UserType.find_by(id: user.type_id)
				if type.can_create_business_place
					business = BusinessPlace.new(business_params)
					business.user_id = user.id
					if business.save
						render :json => {model: business}
					else
						error = {code: 8}
						render :json => {model: error}, status: :bad_request
					end
				else
					error = {code: 7}
					render :json => {model: error}, status: :unauthorized
				end
			else
				error = {code: 6}
				render :json => {model: error}, status: :unauthorized
			end
		else
			error = {code: 5}
			render :json => {model: error}, status: :unauthorized
		end
	end

	private

	def business_params
		params.permit(:name, :domain)
	end

end