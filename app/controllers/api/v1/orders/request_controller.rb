class Api::V1::Orders::RequestController < ApplicationController
	before_action :validate_authentification_token

	def create
		if @token
			if @user
				if @user.type_id < 9 && @user.type_id > 5
					products = params[:products]
					if products
						pTotal = []
						products.each do |p|
							pTemp = BusinessProduct.new(user_id: @user.id, product_id: p[:id], quantity: p[:quantity])
							if pTemp.save
								pTotal << pTemp
							end
						end
						if pTotal.length == products.length
							render :json => pTotal
						else
							error = {code: 26}
							render :json => error, status: :bad_request
						end
					else
						error = {code: 25}
						render :json => error, status: :bad_request
					end
				else
					error = {code: 24}
					render :json => error, status: :bad_request
				end
			end
		end
	end

end