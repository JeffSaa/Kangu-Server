class Api::V1::Userapp::RegisterController < ApplicationController

	def provider
		user = User.new(user_params)
		user.password = SymmetricEncryption.encrypt params[:password]
		user.type_id = 401
		user.downcase_fields
		if user.save
			render :json => user, status: :ok
		else
			error = {code: 123}
			render :json => error, status: :bad_request
		end
	end

	def supervisor
		user = User.new(user_params)
		user.password = SymmetricEncryption.encrypt params[:password]
		user.type_id = 102
		user.downcase_fields
		if user.save
			render :json => user, status: :ok
		else
			error = {code: 123}
			render :json => error, status: :bad_request
		end
	end

	def administrator
		user = User.new(user_params)
		user.password = SymmetricEncryption.encrypt params[:password]
		user.type_id = 101
		user.downcase_fields
		if user.save
			render :json => user, status: :ok
		else
			error = {code: 123}
			render :json => error, status: :bad_request
		end
	end

	def business
		user = User.new(user_params)
		user.password = SymmetricEncryption.encrypt params[:password]
		user.type_id = 301
		user.downcase_fields
		if user.save
			render :json => {email: user.email, name: user.name, lastname: user.lastname, type: user.type_id}
		else
			error = {code: 1}
			render :json => error, status: :bad_request
		end
	end

	def business_employee
		sucursal = BusinessSucursal.find_by(id: params[:sucursal_id])
		if sucursal
			user = User.new(user_params)
			user.password = SymmetricEncryption.encrypt params[:password]
			if user.save
				render :json => user, status: :ok
			else
				error = {code: 15}
				render :json => error, status: :bad_request
			end
		else
			error = {code: 14}
			render :json => error, status: :bad_request
		end
	end

	private

	def user_params
		params.permit(:email, :address_description, :address_latitude, :address_longitude, :name, :lastname,
			:sucursal_id, :phone)
	end

end