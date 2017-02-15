class Api::V1::Categories::CategoriesController < ApplicationController
	before_action :validate_authentification_token

	def create
		categorie = Categorie.new(categorie_params)
		categorie.downcase_fields
		if categorie.save
			render :json => categorie, status: :ok
		else
			render :json => categorie, status: :bad_request
		end
	end

	private

	def categorie_params
		params.permit(:name, :type, :categorie_id)
	end

end