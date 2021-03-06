class User < ApplicationRecord
	validates :email, presence: true
	validates :email, length: { minimum: 5 }
	validates :email, uniqueness: true
	validates :password, presence: true
	validates :name, presence: true
	validates :lastname, presence: true
	validates :address_description, presence: true
	validates :phone, presence: true
	validates :cc, presence: true

	def downcase_fields
		self.name = self.name.downcase
		self.lastname = self.lastname.downcase
		self.email = self.email.downcase
		self.address_description = self.address_description.downcase
	end

end