class Api::V1::Userapp::LogoutController < ApplicationController

	def destroy
		if @token
			if @token.destroy
				render :json => { model: @token.id }
			else
				error = {code: 15}
				render :json => {model: error}, status: :bad_request
			end
		end
	end

end