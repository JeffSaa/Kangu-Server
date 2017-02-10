class BusinessPlace < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	def lowercase
		self.name = name.lowercase
	end

end