class ProductVariant < ApplicationRecord

	def downcase_fields
		self.name = self.name.downcase
		self.description = self.description.downcase
	end

end