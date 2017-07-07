class Api::V1::Products::ProductsController < ApplicationController
	before_action :validate_authentification_token, :except => [:search_product, :index]

	def index
		#response = Product.all.paginate(:per_page => Constants::ITEMS_PER_PAGE, :page => params[:page])
		#set_paginate_header(Constants::ITEMS_PER_PAGE, response, params[:page])
		render :json => {model: Product.all}, status: :ok
	end

	def show
		response = {product: Product.find(params[:id]), variants: ProductVariant.where(product_id: params[:id])}
		render :json => response, status: :ok
	end

	def create
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			product = Product.new(products_params)
			product.downcase_fields
			if product.save
				render :json => {response: product}, status: :ok
			end
		end
	end

	def destroy
		product = Product.find(params[:id]);
		variants = ProductVariant.where(product_id: params[:id])
		render :json => {product: product, variants: variants}, status: :ok
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
		params.permit(:name, :measurement_type, :subcategorie_id)
	end

end