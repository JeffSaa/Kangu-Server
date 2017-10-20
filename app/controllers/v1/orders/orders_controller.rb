class V1::Orders::OrdersController < ApplicationController

	def create
		order = Order.new(order_params)
		if request.headers["Authorization"]
			validate_authentification_token()
			if charge_exist(@current_user, Constants::KANGU_ADMIN)
				order.status = params[:status]
				order.target_id = params[:target_id]
			else
				order.target_id = @current_user.id
			end
		end
		response = {order_info: order, products: []}
		if order
			total = 0
			params[:products].each do |p|
				op = OrderProduct.new(orderproduct_params(p))
				if order.order_type == Constants::ORDER_BUSINESS
					op.price = ProductVariant.find(op.variant_id).business_price
				else
					op.price = ProductVariant.find(op.variant_id).natural_price
				end
				total += op.price * op.quantity
				op.last_quantity = op.quantity
				op.order_id = order.id
				op.iva = ProductVariant.find(p[:variant_id]).iva
				if op
					response[:products] << op
				end
			end
			if order.update(total: total)
				render :json => response, status: :ok
			end
		end
	end

	def index
		response = []
		Order.where(status: params[:status]).each{|o| response << render_order(o)}
		render :json => response, status: :ok
	end

	def show
		render :json => render_order(Order.find(params[:id])), status: :ok
	end

	def find_by_consecutive
		render :json => render_order(Order.find_by(consecutive: params[:consecutive])), status: :ok
	end

	def remove_product
		order_product = OrderProduct.find(params[:id])
		order = Order.find(order_product.order_id)
		if order.status < 2 and order_product.destroy and order.update(total: order.total - order_product.price * order_product.quantity)
			render :json => order, status: :ok
		end
	end

	def add_product	#Agregar producto auna orden.
		op = OrderProduct.new(orderproduct_params(params[:model]))
		response = Order.find(params[:model][:order_id])
		op.order_id = response.id
		op.price = get_product_price(ProductVariant.find(op.variant_id))
		if op.save and response.update(total: response.total + op.price * op.quantity)
			render :json => render_order(response), status: :ok
		end
	end

	def update_product #Editar un producto de una orden
		op = OrderProduct.find(params[:id])
		order = Order.find(op.order_id)
		temp_total = op.price * op.quantity
		temp_q = op.quantity
		if op.update(comment: params[:comment], quantity: params[:quantity], last_quantity: temp_q, price: params[:price]) and order.update(total: op.price * params[:quantity].to_i + order.total - temp_total)
			render :json => render_order(order), status: :ok
		end
	end

	def advance	#Avanzar de estado una orden
		order = Order.find(params[:id])
		case order.status
		when 1 #Pasa de orden a factura
			total = 0
			products = OrderProduct.where(order_id: order.id)
			group = InventoryEntryGroup.new(date: order.datehour.to_date, is_entry: false)
			if group.save
				products.each do |p|
					variant = ProductVariant.find(p.variant_id)
					q_temp = variant.variant_stock -= p.quantity
					ie = InventoryEntry.new(variant_id: variant.id, quantity: p.quantity, group_id: group.id, variant_stock: q_temp) #Crea una entrada de inventario
					cash_balance = Wallet.where(cash_id: Constants::CASH_MINOR).last #Busca el ultimo registro de la caja menor y actualiza la cartera
					last_wallet = Wallet.last
					w = Wallet.new(date: order.datehour.to_date, total: order.total, mov_type: Constants::MOV_TYPE_INCOME, source_type: Constants::RECAUDO_VENTAS,
						cash_id: Constants::CASH_MINOR)
					w.balance = last_wallet.balance + order.total
					w.cash_balance = cash_balance.present? ? cash_balance.cash_balance + order.total : (order.total)
					if order.order_type == Constants::ORDER_BUSINESS
						price = variant.business_price
					else
						price = variant.natural_price
					end
					if p.update(price: price, iva: variant.iva) and variant.update(variant_stock: q_temp) and ie.save and w.save
						total += p.price * p.quantity
					end
				end
			end
			if order.order_type == Constants::ORDER_BUSINESS
				sucursal = BusinessSucursal.find(order.target_id)
				sucursal.update(order_count: sucursal.order_count + 1)
			end
			consecutive = Order.where(status: 3).count + Order.where(status: 4).count + Order.where(status: 2).count + 1
			order.update(consecutive: consecutive, total: total, status: order.status+1)
			render :json => order, status: :ok
		else
			if order.update(status: order.status+1)
				render :json => order, status: :ok
			end
		end
	end

	def return
		change_status(0, params[:id])
	end

	def disable
		change_status(4, params[:id])
	end

	def update_status
		response = []
		params[:products].each do |product|
			p =  OrderProduct.find(product[:id])
			p.update(last_quantity: p.quantity)
			p.update(update_orderproduct_params(product))
			response << p
		end
		render :json => response, status: :ok
	end

	def day_shop	#Obtener compras del dia
		orders = Order.where(status: 1)
		products = []
		duplicates = []
		response = []
		orders.each do |o|
			products.push(*OrderProduct.where(order_id: o.id))
		end
		products = products.group_by{|p| p.variant_id}
		products.each do |p|
			duplicates << p.last
		end
		duplicates.each do |d|
			variant = ProductVariant.find(d.first.variant_id)
			response << {variant: variant, product: Product.find(variant.product_id), duplicates: d,
				quantity: d.inject(0){|sum,e| sum + e.quantity}}
		end
		render :json => response, status: :ok
	end

	def show_by_uid
		order = Order.find_by(uid: params[:uid])
		render :json => render_order(order), status: :ok
	end

	def search_orderproduct
		response = []
		order = Order.find(params[:order_id])
		products = []
		OrderProduct.where(order_id: order.id).each{|op| products << {order_product: op, variant: ProductVariant.find(op.variant_id)}}
		products.each do |p|
			if p[:variant].name.include?(params[:search])
				response << p
			end
		end
		render :json => response, status: :ok
	end

	def payu_method
		order = {
			merchant_pos_id: "145227",
			customer_ip: "127.0.0.1", # You can user request.remote_ip in your controller
			ext_order_id: 1342, #Order id in your system
			order_url: "http://localhost/",
			description: "New order",
			currency_code: "PLN",
			total_amount: 10000,
			notify_url: "http://localhost/",
			buyer: {
				email: 'dd@ddd.pl',
				phone: '123123123',
				first_name: 'Jan',
				last_name: 'Kowalski',
				language: 'PL',
				delivery: {
				street: 'street',
				postal_code: 'postal_code',
				city: 'city',
				country_code: 'PL'
				}
			},
			products: [
				{
					name: 'Mouse',
					unit_price: 10000,
					quantity: 1
				}
			],
				shipping_methods: {
				country: 'PL',
				price: 'price',
				name: 'shipping name'
			}
		}
		response = OpenPayU::Order.create(order)
		render :json => response, status: :ok
	end

	private

	def render_order(order)
		products = []
		order_products = OrderProduct.where(order_id: order.id)
		order_products.each do |op|
			variant = ProductVariant.find(op.variant_id)
			products << {order_product: op, variant: variant, product: Product.find(variant.product_id)}
		end
		iva = []
		[0, 5, 16].each do |i|
			total = 0
			order_products.where(iva: i).each{|op| total += op.price * op.quantity}
			iva << [total ,i * total / 100]
		end
		o =  {order: order, products: products, sucursal: nil, place: nil, iva: iva}
		sucursal = BusinessSucursal.find_by(id: order.target_id)
		if sucursal
			place = BusinessPlace.find_by(id: sucursal.business_id)
			o[:place] = place
			o[:sucursal] = sucursal
		end
		return o
	end

	def update_orderproduct_params(p)
		p.permit(:quantity, :comment, :status)
	end

	def change_status(status, id)
		order = Order.find(id)
		consecutive = nil
		if status == 4
			consecutive = Order.where(status: 3).count + Order.where(status: 4).count + 1
		end
		if order.update(status: status, consecutive: consecutive)
			render :json => order, status: :ok
		end
	end

	def order_params
		params.permit(:comment, :datehour, :order_type, :pay_mode, :wc_name, :wc_lastname, :wc_address, :wc_phone)
	end

	def orderproduct_params(p)
		p.permit(:comment, :quantity, :variant_id)
	end

	def update_orderproduct_param
		params.permit(:comment, :quantity, :price)
	end

	def get_order_details(order)
		products = []
		OrderProduct.where(order_id: order.id).each{|p| products << get_orderproduct_info(p)}
		return {order: Order.find(order.id), products: products}
	end

end