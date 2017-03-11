class Api::V1::Orders::SupervisorController < ApplicationController
	before_action :validate_authentification_token

	def get_supervisor_orders
		response = {received: [], buying: [], deliver: [], completed: [], disabled: []}
		Order.where(status: 0).each do |o|
			orderproduct = OrderProduct.where(order_id: o.id);
			temp = {info: o, products: []}
			orderproduct.each do |p|
				temp_response = {name: "", quantity: p.quantity, comment: p.comment, type_size: 0, type_measure: 0}
				temp_product = Product.find_by(id: p.product_id)
				temp_response[:name] = temp_product.name
				temp_response[:type_size] = temp_product.type_size
				temp_response[:type_measure] = temp_product.type_measure
				temp[:products] << temp_response
			end
			response[:received] << temp
		end
		Order.where(status: 1).each do |o|
			orderproduct = OrderProduct.where(order_id: o.id);
			temp = {info: o, products: []}
			orderproduct.each do |p|
				temp_response = {name: "", quantity: p.quantity, comment: p.comment, type_size: 0, type_measure: 0}
				temp_product = Product.find_by(id: p.product_id)
				temp_response[:name] = temp_product.name
				temp_response[:type_size] = temp_product.type_size
				temp_response[:type_measure] = temp_product.type_measure
				temp[:products] << temp_response
			end
			response[:buying] << temp
		end
		Order.where(status: 2).each do |o|
			orderproduct = OrderProduct.where(order_id: o.id);
			temp = {info: o, products: []}
			orderproduct.each do |p|
				temp_response = {name: "", quantity: p.quantity, comment: p.comment, type_size: 0, type_measure: 0}
				temp_product = Product.find_by(id: p.product_id)
				temp_response[:name] = temp_product.name
				temp_response[:type_size] = temp_product.type_size
				temp_response[:type_measure] = temp_product.type_measure
				temp[:products] << temp_response
			end
			response[:deliver] << temp
		end
		Order.where(status: 3).each do |o|
			orderproduct = OrderProduct.where(order_id: o.id);
			temp = {info: o, products: []}
			orderproduct.each do |p|
				temp_response = {name: "", quantity: p.quantity, comment: p.comment, type_size: 0, type_measure: 0}
				temp_product = Product.find_by(id: p.product_id)
				temp_response[:name] = temp_product.name
				temp_response[:type_size] = temp_product.type_size
				temp_response[:type_measure] = temp_product.type_measure
				temp[:products] << temp_response
			end
			response[:completed] << temp
		end
		Order.where(status: 4).each do |o|
			orderproduct = OrderProduct.where(order_id: o.id);
			temp = {info: o, products: []}
			orderproduct.each do |p|
				temp_response = {name: "", quantity: p.quantity, comment: p.comment, type_size: 0, type_measure: 0}
				temp_product = Product.find_by(id: p.product_id)
				temp_response[:name] = temp_product.name
				temp_response[:type_size] = temp_product.type_size
				temp_response[:type_measure] = temp_product.type_measure
				temp[:products] << temp_response
			end
			response[:disabled] << temp
		end
		render :json => response, status: :ok
	end

	def change_order_status
		order = Order.find(params[:id])
		order.update(status: params[:status])
		render :json => order, status: :ok
	end

end