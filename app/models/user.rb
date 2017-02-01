class User < ApplicationRecord
	validates :email, presence: true
	validates :email, length: { minimum: 5 }
	validates :email, uniqueness: true
	validates :address_description, presence: true
	validates :address_latitude, presence: true
	validates :address_longitude, presence: true
	validates :password, presence: true
end