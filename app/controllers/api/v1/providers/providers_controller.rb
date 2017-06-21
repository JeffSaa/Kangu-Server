class Api::V1::Providers::ProvidersController < ApplicationController
	before_action :validate_authentification_token

	def create
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			provider = Provider.new(provider_params)
			if provider.save
				render :json => provider, status: :ok
			end
		end
	end

	def index
		render :json => {model: Provider.all}, status: :ok
	end

	private

	def provider_params
		params.permit(:name, :variant_id, :user_id)
	end

end