class BusinessSucursal < ApplicationRecord
	validates :business_id, presence: true
	validates :name, presence: true, uniqueness: true

	def downcase_fields
		self.name = name.downcase
	end

end