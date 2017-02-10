class Api::V1::Sucursal::SearchController < ApplicationController
	before_action :validate_authentification_token

	def create
		respond = BusinessPlace.where("name like '#{params[:search]}%'")
		render :json => respond, status: :ok
	end

end