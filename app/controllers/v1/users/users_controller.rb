class V1::Users::UsersController < ApplicationController
	before_action :validate_authentification_token

	def index
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			response = User.all.paginate(:per_page => Constants::ITEMS_PER_PAGE, :page => params[:page])
			set_paginate_header(Constants::ITEMS_PER_PAGE, response, params[:page])
			render :json => response, status: :ok
		end
	end

	def search
		users = []
		if params[:search].length > 0
			q = params[:search].downcase
			users = User.where('email LIKE ?', "%#{params[:search]}%")
		end
		render :json => users, status: :ok
	end

end