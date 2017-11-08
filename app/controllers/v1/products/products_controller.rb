class V1::Products::ProductsController < ApplicationController
	before_action :validate_authentification_token, :except => [:search_product, :index, :products_excel_creator]

	def index
		response = []
		model = Product.all.paginate(:per_page => Constants::ITEMS_PER_PAGE, :page => params[:page])
		model.each{|p| response << {product: p, subcategorie: Categorie.find(p.subcategorie_id)}}
		set_paginate_header(Constants::ITEMS_PER_PAGE, model, params[:page])
		render :json => response, status: :ok
	end

	def show
		response = {product: Product.find(params[:id]), variants: ProductVariant.where(product_id: params[:id])}
		render :json => response, status: :ok
	end

	def create
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			product = Product.new(products_params)
			product.downcase_fields
			if product.save
				render :json => {response: product}, status: :ok
			end
		end
	end

	def destroy
		product = Product.find(params[:id]);
		variants = ProductVariant.where(product_id: params[:id])
		render :json => {product: product, variants: variants}, status: :ok
	end

	def search_product
		products = []
		if params[:search].length > 0
			q = params[:search].downcase
			products = Product.where('name LIKE ?', "%#{params[:search]}%")
		end
		#products = Product.where("name like '#{q}%'").paginate(:per_page => Constants::PRODUCT_PER_PAGE,
			#:page => params[:page])
		#set_paginate_header(response, Constants::PRODUCT_PER_PAGE, products, params[:page])
		render :json => products, status: :ok
	end

	def products_excel_creator
		products = Roo::Spreadsheet.open(params[:products])
		p_c = v_c = 0
		products.each_with_pagename do |name, sheet|
			d = sheet.row(1)
			d1 = d[1].downcase
			product = Product.new()
			if d1 == 'kg'
				product = Product.new(name: d[0], measurement_type: Constants::MEASUREMENT_KG, subcategorie_id: d[2])
			elsif d1 == 'unidad'
				product = Product.new(name: d[0], measurement_type: Constants::MEASUREMENT_UND, subcategorie_id: d[2])
			else
				product = Product.new(name: d[0], measurement_type:  Constants::MEASUREMENT_LT, subcategorie_id: d[2])
			end
			product.downcase_fields
			if product.save
				p_c += 1
				for i in  3..sheet.last_row
					d = sheet.row(i)
					variant = ProductVariant.new(name: d[0], entry_price: d[1], default_quantity: d[2], natural_price: d[3], business_price: d[4], 
						original_image: d[5], description: d[6])
					variant.downcase_fields
					if variant.save
						p variant
						v_c += 1
					end
				end
				p '----'
			end
		end
		render :json => {products: p_c, variants: v_c}
	end

	private

	def products_params
		params.permit(:name, :measurement_type, :subcategorie_id)
	end

end