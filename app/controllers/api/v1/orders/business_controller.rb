class Api::V1::Orders::BusinessController < ApplicationController
	before_action :validate_authentification_token

	def create
		if @user
			products = params[:products]
			list = []
			products.each do |p|
				business_product = BusinessProduct.new(quantity: p[:quantity], product_id: p[:product_id],
					type_measure: p[:type_measure], user_id: @user.id)
				if business_product.save
					list << business_product
				end
			end
			if list.length == products.length
				render :json => list, status: :ok
			else
				render :json => products, status: :bad_request	
			end
		end
	end

end