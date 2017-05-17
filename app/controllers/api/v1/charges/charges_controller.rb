class Api::V1::Charges::ChargesController < ApplicationController
	before_action :validate_authentification_token

	def create
		if charge_exist(@current_user, Constants::FREPI_ADMIN)
			charge = Charge.new(charge_params())
			if charge
				render :json => charge, status: :ok
			end
		end
	end

end