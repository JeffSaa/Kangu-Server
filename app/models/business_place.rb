class BusinessPlace < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	def downcase_fields
		self.name = name.downcase
	end

end