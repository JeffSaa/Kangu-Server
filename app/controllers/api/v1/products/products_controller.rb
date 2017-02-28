class Api::V1::Products::ProductsController < ApplicationController
	before_action :validate_authentification_token, :except => [:search_product]

	def create
		if not @user
			product = Product.new(products_params)
			product.downcase_fields
			if product.save
				upload_blob("productsphotos", params[:photo], product.id)
				render :json => product, status: :ok
			end
		end
	end

	def search_product
		q = params[:search].downcase
		response = Product.where("name like '#{q}%'")
		render :json => {model: response}, status: :ok
	end

	private

	def products_params
		params.permit(:name, :entry_price, :natural_price, :business_price, :subcategorie_id, :provider_may_id,
			:provider_min_id, :type_size, :cant_min_may)
	end

end