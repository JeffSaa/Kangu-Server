class Api::V1::Providers::ProviderController < ApplicationController

	def search
		q = params[:search].downcase
		respond = User.where("email like '#{q}%'")
		render :json => respond, status: :ok
	end

end