class Api::V1::Products::ProductsController < ApplicationController
	before_action :validate_authentification_token

	def create
		if @user
			product = Product.new(products_params)
			render :json => product, status: :ok
		end
	end

	private

	def products_params
		params.permit(:name, :entry_price, :natural_price, :business_price, :subcategorie_id, :enabled,
			:provider_may_id, :provider_min_id, :type_size, :cant_min_may)
	end

end