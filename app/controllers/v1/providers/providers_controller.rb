class V1::Providers::ProvidersController < ApplicationController
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
		render :json => response, status: :ok
	end

	def assign
		response = create_charge()
		response.type_id = Constants::KANGU_PROVIDER
		if response.save		
			render :json => response, status: :ok
		end
	end

	private

	def provider_params
		params.permit(:name, :user_id)
	end

end