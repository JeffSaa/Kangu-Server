class ProductVariant < ApplicationRecord

	def downcase_fields
		self.name = self.name.downcase
	end

end