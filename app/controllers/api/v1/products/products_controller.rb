class Api::V1::Products::ProductsController < ApplicationController
	before_action :validate_authentification_token, :except => [:search_product]

	def create
		if charge_exist(@current_user, Constants::FREPI_ADMIN)
			product = Product.new(products_params)
			product.downcase_fields
			if product.save
				upload_blob("product", params[:photo], product.id)
				render :json => {response: product}, status: :ok
			end
		end
	end

	def search_product
		products = []
		if params[:search].length > 0
			q = params[:search].downcase
			products = Product.where('name LIKE ?', "%#{params[:search]}%")
		end
		#products = Product.where("name like '#{q}%'").paginate(:per_page => Constants::PRODUCT_PER_PAGE,
			#:page => params[:page])
		#set_paginate_header(response, Constants::PRODUCT_PER_PAGE, products, params[:page])
		render :json => {model: products}, status: :ok
	end

	private

	def products_params
		params.permit(:name)
	end

end