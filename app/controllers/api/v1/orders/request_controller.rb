class Api::V1::Orders::RequestController < ApplicationController

	def create
		token = Token.find_by(id: request.headers["Authorization"])
		if token
			user = User.find_by(id: token.user_id)
			if user
				if user.type_id < 9
					products = params[:products]
					if products
						pTotal = []
						products.each do |p|
							pTemp = BusinessProduct.new(user_id: user.id, product_id: p[:id], quantity: p[:quantity])
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
			else
				error = {code: 23}
				render :json => error, status: :bad_request
			end
		else
			error = {code: 22}
			render :json => error, status: :bad_request
		end
	end

end