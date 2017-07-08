class BusinessPlace < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	def downcase_fields
		self.name = name.downcase
	end

	def credit_status
		BusinessPlace.where('current_deb > ?', 0).each do |bp|
			user = getPlaceOwner(bp.id)
			ConvertLoop.people.create_or_update(email: user.email, first_name: user.name, last_name: user.lastname, total: 0, token: bp.uid)
			ConvertLoop.event_logs.send(name: "credit-status", person: { email: user.email })
		end
	end

end