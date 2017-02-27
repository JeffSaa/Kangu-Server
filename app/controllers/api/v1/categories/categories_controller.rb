class Api::V1::Categories::CategoriesController < ApplicationController
	before_action :validate_authentification_token, :except => [:create, :searchsub, :get_all_cat_and_subcat]

	def create
		categorie = Categorie.new(categorie_params)
		categorie.downcase_fields
		if categorie.save
			render :json => categorie, status: :ok
		else
			render :json => categorie, status: :bad_request
		end
	end

	def searchsub
		q = params[:search].downcase
		response = Categorie.where("name like '#{q}%'")
		render :json => response, status: :ok
	end

	def get_all_cat_and_subcat
		categories = Categorie.where(categorie_type: 0)
		response = []
		categories.each do |c|
			subcategorie = Categorie.where(categorie_id: c.id,categorie_type: 1)
			response << {categorie: c, subcategories: subcategorie}
		end
		render :json => response, status: :ok
	end

	private

	def categorie_params
		params.permit(:name, :categorie_type, :categorie_id)
	end

end