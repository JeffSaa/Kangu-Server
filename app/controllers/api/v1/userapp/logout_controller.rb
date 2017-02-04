class Api::V1::Userapp::LogoutController < ApplicationController

	def destroy
		token = Token.find_by(id: params[:id])
		if token
			if token.destroy
				render :json => { model: token.id }
			else
				error = {code: 17}
				render :json => {model: error}, status: :bad_request
			end
		else
			error = {code: 16}
			render :json => {model: error}, status: :not_found
		end
	end

end