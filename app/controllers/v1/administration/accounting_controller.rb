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
		response = InventoryEntry.new(entry_params)
		render :json => response, status: :ok
	end

	private

	def entry_params
		params.permit(:date, :bill_number, :provider_id, :variant_id, :quantity, :unit_value, :is_payed, :pay_day)
	end

end