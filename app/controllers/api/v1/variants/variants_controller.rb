class Api::V1::Variants::VariantsController < ApplicationController
	before_action :validate_authentification_token, :except => [:search_product]

	def create
		if charge_exist(@current_user, Constants::FREPI_SUPERVISOR)
			variant = ProductVariant.new(variant_params)
			variant.downcase_fields
			if variant.save
				upload_blob("variant", params[:photo], variant.id)
				render :json => variant, status: :ok
			end
		end
	end

	def search
		variants = []
		if params[:search].length > 0
			q = params[:search].downcase
			variants = ProductVariant.where('name LIKE ?', "%#{params[:search]}%")
		end
		render :json => {model: variants}, status: :ok
	end

	private

	def variant_params
		params.permit(:name, :entry_price, :natural_percent, :natural_gain, :business_percent, :business_gain, :coin_price,
			:discount, :subcategorie_id, :measurement_type, :measurement_variant, :unit_measurement, :default_quantity, :product_id)
	end

end