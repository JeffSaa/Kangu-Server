class Api::V1::Sucursal::SucursalController < ApplicationController
	before_action :validate_authentification_token, :except => [:get_user_request, :search_sucursal]

	def create
		if @token
			if @user
				if @user.type_id == 301
					sucursal = BusinessSucursal.new(business_params)
					sucursal.downcase_fields
					if sucursal.save
						render :json => {name: sucursal}, status: :ok
					else
						error = {code: 13}
						render :json => error, status: :bad_request
					end
				else
					error = {code: 12}
					render :json => error, status: :bad_request
				end
			end
		end
	end

	def get_user_request
		request = User.where(active: true, sucursal_id: params[:sucursal_id], type_id: 501)
		render :json => {model: request}, status: :ok
	end

	def accept_user_request
		empl = User.find_by(id: params[:user_id])
		if empl
			empl.update(type_id: params[:type_id])
			render :json => empl, status: :ok
		else
			error = {code: 16}
			render :json => error, status: :bad_request
		end
	end

	def search_sucursal
		q = params[:search].downcase
		response = BusinessSucursal.where("name like '#{q}%'")
		render :json => {model: response}, status: :ok
	end

	def get_all_sucursal_ofplace
		response = BusinessSucursal.where(business_id: params[:id])
		render :json => {model: response}, status: :ok
	end

	def delete_user
	end

	private

	def business_params
		params.permit(:business_id, :name, :phone, :address_description, :address_longitude, :address_latitude)
	end

end