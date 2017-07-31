class Order < ApplicationRecord

	def self.interest_order
		Order.where(order_type: 0, is_payed: false, next_interest_day: Date.today).each do |o|
			o.update(interest_count: o.interest_count + 1, next_interest_day: o.next_interest_day + 30)
			sucursal = BusinessSucursal.find(o.target_id)
			place = BusinessPlace.find(sucursal.business_id)
			Charge.where(target_id: place.id, type_id: Constants::BUSINESS_OWNER).each do |ch|
				user = User.find(ch.user_id)
				ConvertLoop.people.create_or_update(email: user.email, first_name: user.name, last_name: user.lastname, total: 0, token: place.uid)
				ConvertLoop.event_logs.send(name: "order-interest", person: { email: user.email })
			end
		end
	end

end