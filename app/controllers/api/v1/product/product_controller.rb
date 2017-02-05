class Api::V1::Product::ProductController < ApplicationController

	def index
		render :json => {model: 2}
	end

end