class User < ApplicationRecord
	validates :email, presence: true
	validates :email, length: { minimum: 5 }
	validates :email, uniqueness: true
	validates :password, presence: true
end