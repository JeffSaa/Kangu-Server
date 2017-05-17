class Api::V1::Userapp::LogoutController < ApplicationController

	def destroy
		token = Token.find_by(id: params[:id])
		if token
			if token.destroy
				render :json => { model: token }, status: :ok
			else
				render_response_json(15, :bad_request)
			end
		end
	end

end