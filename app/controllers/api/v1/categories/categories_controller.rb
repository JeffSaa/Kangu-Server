class Api::V1::Categories::CategoriesController < ApplicationController
	before_action :validate_authentification_token, :except => [:create, :searchsub]

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
		respond = Categorie.where("name like '#{q}%'")
		render :json => respond, status: :ok
	end

	private

	def categorie_params
		params.permit(:name, :categorie_type, :categorie_id)
	end

end