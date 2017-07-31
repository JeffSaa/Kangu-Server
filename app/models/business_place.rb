class BusinessPlace < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	def downcase_fields
		self.name = name.downcase
	end

	def self.credit_status
		BusinessPlace.where('current_deb > ?', 0).each do |bp|
			Charge.where(target_id: bp.id, type_id: Constants::BUSINESS_OWNER).each do |ch|
				user = User.find(ch.user_id)
				ConvertLoop.people.create_or_update(email: user.email, first_name: user.name, last_name: user.lastname, total: bp.current_deb, token: bp.uid)
				ConvertLoop.event_logs.send(name: "credit-status", person: { email: user.email })
			end
		end
	end

end