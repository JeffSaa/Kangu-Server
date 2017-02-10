class Api::V1::Business::BusinessController < ApplicationController
	before_action :validate_authentification_token

	def create
		if @token
			if @user
				if @user.type_id == 301
					business = BusinessPlace.new(business_params)
					business.user_id = @user.id
					if business
						upload_blob("sucursalphotos", params[:photo])
						render :json => {name: business.name}, status: :ok
					else
						error = {code: 9}
						render :json => error, status: :bad_request
					end
				else
					error = {code: 8}
					render :json => error, status: :bad_request
				end
			end
		end
	end

	private

	def business_params
		params.permit(:name, :photo)
	end

end