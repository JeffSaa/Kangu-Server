class BusinessSucursal < ApplicationRecord
	validates :business_id, presence: true
	validates :name, presence: true
end