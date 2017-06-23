class Api::V1::Providers::ProvidersController < ApplicationController
	before_action :validate_authentification_token

	def create
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			provider = Provider.new(provider_params)
			provider.downcase_fields
			if provider.save
				render :json => provider, status: :ok
			end
		end
	end

	def index
		render :json => {model: Provider.all}, status: :ok
	end

	def search
		response = []
		if params[:search].length > 0
			q = params[:search].downcase
			Provider.where('name LIKE ?', "%#{params[:search]}%").each{|p| response << {provider: p, user: User.find(p.user_id)}}

		end
		render :json => {model: response}, status: :ok
	end

	private

	def provider_params
		params.permit(:name, :user_id)
	end

end