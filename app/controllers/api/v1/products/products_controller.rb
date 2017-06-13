class Api::V1::Products::ProductsController < ApplicationController
	before_action :validate_authentification_token, :except => [:search_product]

	def index
		render :json => {model: Product.all}, status: :ok
	end

	def show
		response = {product: Product.find(params[:id]), variants: ProductVariant.where(product_id: params[:id])}
		render :json => response, status: :ok
	end

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

	def products_excel_creator
		excel = Roo::Spreadsheet.open(params[:excel])
		product = Product.new(name: excel.cell(5,1), measurement_type: excel.cell(5,2), measurement_variant: excel.cell(5,3),
			subcategorie_id: excel.cell(5,4))
		target = 8
		variants = []
		product.downcase_fields
		if product.save
			sw = true
			while(sw and target < excel.last_row) do
				if excel.cell(target+1,1) == nil
					sw = false
				else
					target += 1
				end
			end
			for i in 9..target
				variant = ProductVariant.new(name: excel.cell(i,1), entry_price: excel.cell(i,2), natural_price: excel.cell(i,7),
					business_price: excel.cell(i,8), unit_quantity: excel.cell(i,5), default_quantity: excel.cell(i,6), product_id: product.id)
				variant.downcase_fields
				if variant.save
					variants << variant
				end
			end
		end
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
		params.permit(:name, :measurement_type, :measurement_variant, :subcategorie_id)
	end

end