class BusinessPlace < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	validates :domain, presence: true, uniqueness: true
end