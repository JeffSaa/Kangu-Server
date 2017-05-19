class Api::V1::Product::ProductController < ApplicationController
	before_action :validate_authentification_token, :except => [:search_product]

	def create
		if charge_exist(@current_user, Constants::FREPI_SUPERVISOR)
			product = Product.new(products_params)
			product.downcase_fields
			if product.save
				upload_blob("product", params[:photo], product.id)
				render :json => product, status: :ok
			end
		end
	end

	def search_product
		q = params[:search].downcase
		products = Product.where("name like '#{q}%'").paginate(:per_page => Constants::PRODUCT_PER_PAGE,
			:page => params[:page])
		set_paginate_header(response, Constants::PRODUCT_PER_PAGE, products, params[:page])
		render :json => {model: products}, status: :ok
	end

	private

	def products_params
		params.permit(:name)
	end

end