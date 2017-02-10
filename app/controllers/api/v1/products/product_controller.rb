class Api::V1::Products::ProductController < ApplicationController
	before_action :validate_authentification_token

	def create
		if @token
			if @user
				if @user.type_id < 4
					product = Product.new(product_params)
					if product.save
						render :json => product, status: :ok
					else
						error = {code: 21}
						render :json => error, status: :bad_request
					end
				else
					error = {code: 20}
					render :json => error, status: :bad_request
				end
			end
		end
	end

	private

	def product_params
		params.permit(:name, :group_id, :entry_price, :natural_price, :business_price, :subcategorie_id,
			:enabled, :coin_price, :discount, :provider_may_id, :provider_min_id, :type_size, :cant_min_may)
	end

end