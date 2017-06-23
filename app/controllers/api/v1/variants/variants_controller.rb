class Api::V1::Variants::VariantsController < ApplicationController
	before_action :validate_authentification_token, :except => [:search_product]

	def create
		if charge_exist(@current_user, Constants::KANGU_SUPERVISOR)
			variant = ProductVariant.new(variant_params)
			variant.downcase_fields
			if variant.save
				params[:type_id] = Constants::KANGU_PROVIDER
				params[:user_id] = params[:provider_id]
				params[:target_id] = variant.id
				charge = create_charge()
				if charge.save
					upload_blob("variant", params[:photo], variant.id)
					render :json => {variant: variant, charge: charge}, status: :ok
				end
			end
		end
	end

	def search
		response = []
		if params[:search].length > 0
			q = params[:search].downcase
			ProductVariant.where('name LIKE ?', "%#{params[:search]}%").each{|p| response <<
				{variant: p, product: Product.find(p.product_id)}}
		end
		render :json => {model: response}, status: :ok
	end

	private

	def variant_params
		params.permit(:name, :entry_price, :natural_percent, :natural_gain, :business_percent, :business_gain, :coin_price,
			:discount, :unit_measurement, :default_quantity, :product_id, :description)
	end

end