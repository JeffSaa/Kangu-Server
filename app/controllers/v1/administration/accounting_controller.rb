class V1::Administration::AccountingController < ApplicationController
	before_action :validate_authentification_token

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
		response = []
		entries = params[:entries]
		entries.each do |e|
			entry = InventoryEntry.new(entry_params(e))
			entry.date = params[:date]
			entry.bill_number = params[:bill_number]
			entry.provider_id = params[:provider_id]
			entry.is_payed = params[:is_payed]
			entry.pay_day = params[:pay_day]
			if entry.save
				response << entry				
			end
		end 
		render :json => response, status: :ok
	end

	def income_expenses
		response = Wallet.new(income_expenses_params)
		if response.mov_type == Constants::MOV_TYPE_INCOME
			response.balance = Wallet.last.balance + response.total
		else
			response.balance = Wallet.last.balance - response.total
		end
		if response.save
			render :json => response, status: :ok
		end
	end

	private

	def income_expenses_params
		params.permit(:date, :total, :mov_type, :source_type, :third_type, :third_id)
	end

	def entry_params(e)
		e.permit(:date, :bill_number, :provider_id, :variant_id, :quantity, :unit_value, :is_payed, :pay_day)
	end

end