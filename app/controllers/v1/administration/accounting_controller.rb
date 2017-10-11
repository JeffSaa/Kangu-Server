class V1::Administration::AccountingController < ApplicationController
	before_action :validate_authentification_token, :except => [:download_csv]

	def close_day
		response = {total: 0, model: []}
		day = DateTime.parse params[:day]
		orders = Order.where(status: 3).where('datehour BETWEEN ? AND ?', day.beginning_of_day, day.end_of_day)
		orders.each do |o|
			products = []
			OrderProduct.where(order_id: o.id).each{|op| products << get_orderproduct_info(op)}
			response[:total] += o.total
			notes = []
			CreditNote.where(order_id: o.id).each do |cn|
				items = []
				CreditNoteItem.where(note_id: cn).each do |cni|
					order_product = OrderProduct.find(cni.product_id)
					variant = ProductVariant.find(order_product.variant_id)
					product = Product.find(variant.product_id)
					items << {item: cni, variant: variant, product: product, order_product: order_product}
				end
				notes << {credit_note: cn, notes: items}
			end
			response[:model] << {order: o, order_products: products, credit_notes: notes}
		end
		render :json => response, status: :ok
	end

	def inventory_entry
		response = {group: nil, entries: []}
		response[:group] = InventoryEntryGroup.new(group_params)
		if response[:group].save
			params[:entries].each do |e|
				e = InventoryEntry.new(entry_params(e))
				e.group_id = response[:group].id
				if e.save
					variant = ProductVariant.find(e.variant_id)
					variant.update(variant_stock: variant.variant_stock += e.quantity)
					e.update(variant_stock: variant.variant_stock)
					response[:entries] << {entry: e, variant: variant}
				end
			end
		end
		render :json => response, status: :ok
	end

	def inventory_movements
		response = []
		InventoryEntryGroup.where(date: params[:date]).each do |g|
			entries = []
			InventoryEntry.where(group_id: g.id).each do |ie|
				variant = ProductVariant.find(ie.variant_id)
				entries << {entry: ie, variant: variant, product: Product.find(variant.product_id)}
			end
			response << {group: g, entries: entries}
		end
		render :json => response, status: :ok
	end

	def income_expenses
		response = Wallet.new(income_expenses_params)
		cash_balance = Wallet.where(cash_id: params[:cash_id]).last
		last_wallet = Wallet.last
		if response.mov_type == Constants::MOV_TYPE_INCOME
			response.balance = last_wallet.balance + response.total
			response.cash_balance = cash_balance.present? ? cash_balance.cash_balance + response.total : (response.total)
		else
			response.balance = last_wallet.balance - response.total
			response.cash_balance = cash_balance.present? ? cash_balance.cash_balance - response.total : (response.total * -1)
		end
		if response.save
			render :json => response, status: :ok
		end
	end

	def income_expenses_movements
		response = Wallet.where(date: params[:date])
		render :json => response, status: :ok
	end

	def download_csv
		csv_string = CSV.generate do |csv|
			csv << ["SKU", "Name", "Natural Price", "Business Price", "Categories"]
			ProductVariant.all.each do |v|
				sub = Categorie.find(Product.find(v.product_id).subcategorie_id)
				cat = Categorie.find(sub.categorie_id)
				cat_s = cat.name.capitalize+" > "+sub.name.capitalize
				csv << [v.id,v.name.capitalize,v.natural_price,v.business_price,cat_s]
			end
		end
		respond_to do |format|
			format.csv { send_data csv_string }
		end
	end

	private

	def income_expenses_params
		params.permit(:date, :total, :mov_type, :source_type, :third_type, :third_id, :cash_id)
	end

	def group_params
		params.permit(:date, :bill_number, :provider_id, :is_payed, :pay_day)
	end

	def entry_params(e)
		e.permit(:variant_id, :quantity, :unit_value)
	end

end