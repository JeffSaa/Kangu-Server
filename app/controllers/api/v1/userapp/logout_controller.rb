class Api::V1::Userapp::LogoutController < ApplicationController

	def destroy
		token = Token.find_by(id: params[:id])
		if token
			if token.destroy
				render :json => { model: token.id }
			else
				error = {code: 15}
				render :json => {model: error}, status: :bad_request
			end
		else
			error = {code: 14}
			render :json => {model: error}, status: :not_found
		end
	end

end