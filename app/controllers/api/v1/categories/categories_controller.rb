class Api::V1::Categories::CategoriesController < ApplicationController
	before_action :validate_authentification_token, :except => [:index]

	def create
		if charge_exist(@current_user, Constants::FREPI_ADMIN)
			categorie = Categorie.new(categorie_params)
			categorie.downcase_fields
			if categorie
				render :json => categorie, status: :ok
			else
				render :json => categorie, status: :bad_request
			end
		end
	end

	def index
		render :json => {model: Categorie.all.where(categorie_type: params[:type])}, status: :ok
	end

	def search_subcategorie
		q = params[:search].downcase
		response = Categorie.where('name LIKE ?', "%#{q}%").where(categorie_type: params[:type])
		render :json => response, status: :ok
	end

	private

	def categorie_params
		params.permit(:name, :categorie_type, :categorie_id)
	end

end