class V1::Creditnote::CreditnoteController < ApplicationController
	before_action :validate_authentification_token

	def create
		if charge_exist(@current_user, Constants::KANGU_ADMIN)
			response = {note: nil, items: []}
			note = CreditNote.new(note_params)
			note.consecutive = CreditNote.count + 1
			total = 0
			if note.save
				params[:notes].each do |i|
					item = CreditNoteItem.new(note_item_params(i))
					item.note_id = note.id
					if item.save
						response[:items] << item
						op = OrderProduct.find(item.product_id)
						total += get_product_price(ProductVariant.find(op.variant_id)) * item.quantity
					end
				end
				if note.update(total: total)
					response[:note] = note
					render :json => response, status: :ok					
				end
			end
		end
	end

	private

	def note_params
		params.permit(:order_id)
	end

	def note_item_params(i)
		i.permit(:product_id, :quantity)
	end

end