class Api::V1::Userapp::RegisterController < ApplicationController

	def provider
		user = create_user(401)
		if user.save
			send_confirmation_mail(user)
			render :json => user, status: :ok
		else
			error = {code: 123}
			render :json => error, status: :bad_request
		end
	end

	def supervisor
		user = create_user(102)
		if user.save
			send_confirmation_mail(user)
			render :json => user, status: :ok
		else
			error = {code: 123}
			render :json => error, status: :bad_request
		end
	end

	def administrator
		user = create_user(101)
		if user.save
			send_confirmation_mail(user)
			render :json => user, status: :ok
		else
			error = {code: 123}
			render :json => error, status: :bad_request
		end
	end

	def business
		user = create_user(301)
		if user.save
			send_confirmation_mail(user)
			render :json => user, status: :ok
		else
			error = {code: 1}
			render :json => error, status: :bad_request
		end
	end

	def business_employee
		sucursal = BusinessSucursal.find_by(id: params[:sucursal_id])
		if sucursal
			user = create_user(501)
			if user.save
				send_confirmation_mail(user)
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

	def confirmation_email
		user = User.find_by(uuid: params[:uuid])
		if user
			user.update(active: true)
		end
		render :json => user, status: :ok
	end

	private

	def send_confirmation_mail(user)
		RegisterMailer.confirm_account(user).deliver_later
	end

	def create_user(type)
		user = User.new(user_params)
		user.type_id = type
		user.password = SymmetricEncryption.encrypt params[:password]
		user.downcase_fields
		return user
	end

	def user_params
		params.permit(:email, :address_description, :address_latitude, :address_longitude, :name, :lastname,
			:sucursal_id, :phone)
	end

end