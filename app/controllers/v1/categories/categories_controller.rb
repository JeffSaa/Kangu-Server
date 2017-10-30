class V1::Categories::CategoriesController < ApplicationController
	before_action :validate_authentification_token

	def create
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			categorie = Categorie.new(categorie_params)
			categorie.downcase_fields
			if categorie.save
				render :json => categorie, status: :ok
			else
				render :json => categorie, status: :bad_request
			end
		end
	end

	def index
		render :json => {model: Categorie.all.where(categorie_type: params[:type])}, status: :ok
	end

	def show
		response = {categorie: Categorie.find(params[:id]), subcategories:
			Categorie.all.where(categorie_type: 1, categorie_id: params[:id])}
		render :json => response, status: :ok
	end

	def search
		q = params[:search].downcase
		response = Categorie.where('name LIKE ?', "%#{q}%").where(categorie_type: params[:type])
		render :json => response, status: :ok
	end

	private

	def categorie_params
		params.permit(:name, :categorie_type, :categorie_id)
	end

end