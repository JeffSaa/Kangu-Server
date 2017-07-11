class V1::Charge::ChargeController < ApplicationController
	before_action :validate_authentification_token

	def create
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			charge = create_charge()
			if charge.save
				render :json => charge, status: :ok
			end
		end
	end

end