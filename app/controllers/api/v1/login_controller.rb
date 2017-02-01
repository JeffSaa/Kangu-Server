class Api::V1::LoginController < ApplicationController

	def create
		password = SymmetricEncryption.encrypt params[:password]
		user = User.find_by(email: params[:email], password: password)
		if user
			token = Token.new(user_id: user.id)
			if token.save
				render :json => { model: token.id }, status: :ok
			else
				render :json => {model: "Ups..."}, status: :bad_request
			end
		else
			render :json => {model: "User not found"}, status: :not_found
		end
	end

	def index
		en = SymmetricEncryption.encrypt "Sensitive data"
		de = SymmetricEncryption.decrypt en
		data = {en: en, de: de}
		render :json => {model: data}
	end

	private

	def user_params
		params.permit(:email, :password)
	end

end