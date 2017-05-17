class Api::V1::Charges::ChargesController < ApplicationController
	before_action :validate_authentification_token

	def create
		if charge_exist(@current_user, Constants::FREPI_ADMIN)
			charge = Charge.new(charge_params)
			if charge.save
				render :json => charge, status: :ok
			end
		end
	end

	private

	def charge_params
		params.permit(:user_id, :target_id, :type_id)
	end

end