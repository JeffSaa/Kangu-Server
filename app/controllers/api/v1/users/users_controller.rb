class Api::V1::Users::UsersController < ApplicationController
	before_action :validate_authentification_token

	def index
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			response = User.all.paginate(:per_page => Constants::ITEMS_PER_PAGE, :page => params[:page])
			set_paginate_header(Constants::ITEMS_PER_PAGE, response, params[:page])
			render :json => {model: response}, status: :ok
			#products = Product.where("name like '#{q}%'").paginate(:per_page => Constants::PRODUCT_PER_PAGE,
			#:page => params[:page])
		#set_paginate_header(response, Constants::PRODUCT_PER_PAGE, products, params[:page])
		end
	end

	def search
		users = []
		if params[:search].length > 0
			q = params[:search].downcase
			users = User.where('email LIKE ?', "%#{params[:search]}%")
		end
		render :json => {model: users}, status: :ok
	end

end