class Api::V1::Users::UsersController < ApplicationController
	before_action :validate_authentification_token

	def index
		if charge_exist(@current_user, Constants::FREPI_ADMIN)
			render :json => {model: User.all}, status: :ok
		end
	end

	def search
		users = []
		if params[:search].length > 0
			q = params[:search].downcase
			users = User.where('name LIKE ?', "%#{params[:search]}%")
		end
		render :json => {model: users}, status: :ok
	end

end