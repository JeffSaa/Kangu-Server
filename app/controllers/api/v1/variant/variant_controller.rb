class Api::V1::Variant::VariantController < ApplicationController
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

	private

	def variant_params
		params.permit(:name, :entry_price, :natural_price, :business_price, :coin_price, :discount, :subcategorie_id,
			:measurement_type, :measurement_variant, :unit_quantity, :default_quantity, :product_id)
	end

end