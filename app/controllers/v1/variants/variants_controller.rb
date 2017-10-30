class V1::Variants::VariantsController < ApplicationController
	before_action :validate_authentification_token, :except => [:search_product, :excel_updater, :search]

	def index
		response = ProductVariant.all.paginate(:per_page => Constants::ITEMS_PER_PAGE, :page => params[:page])
		set_paginate_header(Constants::ITEMS_PER_PAGE, response, params[:page])
		render :json => response, status: :ok
	end

	def create
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			variant = ProductVariant.new(variant_params)
			variant.downcase_fields
			if params[:photo] and variant.save
				image_name = variant.name.gsub(' ','_')+'_original_k'+variant.id.to_s
				variant.update(original_image: image_name)
				upload_blob("variant", params[:photo], image_name)
				render :json => variant, status: :ok
			end
		end
	end

	def show
		variant = ProductVariant.find(params[:id])
		providers = []
		::Charge::where(type_id: Constants::KANGU_PROVIDER, target_id: variant.id).each do |p|
			pro = Provider.find(p.user_id)
			user = User.find(pro.user_id)
			providers << {info: pro, user: user}
		end 
		response = {variant: variant, product: Product.find(variant.product_id), providers: providers}
		render :json => response, status: :ok
	end

	def update
		variant = ProductVariant.find(params[:id])
		if variant.update(variant_params)
			if params[:photo]
				image_name = variant.name.gsub(' ','_')+'_original_k'+variant.id.to_s
				variant.update(original_image: image_name)
				upload_blob("variant", params[:photo], variant.original_image)
			end
			render :json => variant, status: :ok
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
			:discount, :unit_measurement, :default_quantity, :product_id, :description, :iva, :business_price, :natural_price)
	end

end