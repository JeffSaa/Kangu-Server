class V1::Variants::VariantsController < ApplicationController
	before_action :validate_authentification_token, :except => [:search_product, :index, :excel_updater, :search]

	def index
		password = SymmetricEncryption.encrypt params[:password]
		user = User.find_by(email: params[:email], password: password)
		if user and user.active and charge_exist(user, Constants::KANGU_ADMIN)
			render :json => ProductVariant.all, status: :ok
		else
			render :json => {}, status: :not_found
		end
	end

	def create
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			variant = ProductVariant.new(variant_params)
			variant.downcase_fields
			if params[:photo] and variant.save
				image_name = variant.name.gsub(' ','_')+'_k'+variant.id.to_s
				variant.update(original_image: image_name)
				upload_blob("variant", params[:photo], image_name)
				render :json => variant, status: :ok
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
		render :json => response, status: :ok
	end

	def excel_updater
		password = SymmetricEncryption.encrypt params[:password]
		user = User.find_by(email: params[:email], password: password)
		if user and user.active and charge_exist(user, Constants::KANGU_ADMIN)
			response = []
			products = params[:products]
			products = products.each_slice(1).to_a
			products.each do |p|
				vp = p.first.last
				variant = ProductVariant.find(vp[:id])
				if variant.update(business_gain: vp[:business_gain], business_percent: vp[:business_percent],
					coin_price: vp[:coin_price], default_quantity: vp[:default_quantity], description: vp[:description],
					discount: vp[:discount], enabled: vp[:enabled], entry_price: vp[:entry_price], iva: vp[:iva],
					natural_gain: vp[:natural_gain], natural_percent: vp[:natural_percent], unit_measurement: vp[:unit_measurement])
					response << variant
				end
			end
			render :json => response, status: :ok
		else
			render :json => {}, status: :not_found
		end
	end

	private

	def variant_params
		params.permit(:name, :entry_price, :natural_percent, :natural_gain, :business_percent, :business_gain, :coin_price,
			:discount, :unit_measurement, :default_quantity, :product_id, :description, :iva)
	end

end