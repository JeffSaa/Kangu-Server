class Api::V1::Products::ProductsController < ApplicationController
	before_action :validate_authentification_token, :except => [:search_product]

	def create
		if @user
			product = Product.new(products_params)
			product.downcase_fields
			if product.save
				upload_blob("products", params[:photo], product.id)
				render :json => product, status: :ok
			end
		end
	end

	def get_products_info
		if @user
			products = params[:products]
			response = []
			products.each do |p|
				response << Product.find(p[:id])
			end
			render :json => {model: response}, status: :ok
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
		params.permit(:name, :entry_price, :natural_price, :business_price, :subcategorie_id, :provider_may_id,
			:provider_min_id, :type_size, :cant_min_may, :unit_size, :type_measure, :default_quantity)
	end

end