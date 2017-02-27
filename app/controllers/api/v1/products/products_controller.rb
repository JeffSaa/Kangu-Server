class Api::V1::Products::ProductsController < ApplicationController

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

	private

	def products_params
		params.permit(:name, :entry_price, :natural_price, :business_price, :subcategorie_id, :provider_may_id,
			:provider_min_id, :type_size, :cant_min_may)
	end

end