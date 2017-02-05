class Api::V1::Business::BusinessController < ApplicationController

	def create
		token = Token.find_by(id: request.headers["Authorization"])
		if token
			user = User.find_by(id: token.user_id)
			if user
				if user.type_id == 5
					business = BusinessPlace.new(business_params)
					business.user_id = user.id
					if business.save
						render :json => {name: business.name, domain: business.domain}, status: :ok
					else
						error = {code: 9}
						render :json => error, status: :bad_request
					end
				else
					error = {code: 8}
					render :json => error, status: :bad_request
				end
			else
				error = {code: 7}
				render :json => error, status: :bad_request
			end
		else
			error = {code: 6}
			render :json => error, status: :bad_request
		end
	end

	private

	def business_params
		params.permit(:name, :domain)
	end

end