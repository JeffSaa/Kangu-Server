class Api::V1::Sucursal::SucursalController < ApplicationController
	before_action :validate_authentification_token, :except => [:get_user_request, :search_sucursal]

	def create
		if @token
			if @user
				if @user.type_id == 301
					sucursal = BusinessSucursal.new(business_params)
					sucursal.downcase_fields
					if sucursal.save
						render :json => {name: sucursal.name}, status: :ok
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
		requests = User.where(active: false, sucursal_id: params[:sucursal_id])
		render :json => requests, status: :ok
	end

	def accept_user_request
		empl = User.find_by(id: params[:user_id])
		if empl
			if params[:type_id].to_i > 301 && params[:type_id].to_i < 305
				if params.has_key?(:sucursal_id)
					sucursal = BusinessSucursal.find_by(id: params[:sucursal_id])
					business = BusinessPlace.find_by(id: sucursal.business_id)
					if business.user_id == @user.id
						empl.update(active: true, sucursal_id: sucursal.id, type_id: params[:type_id])
						render :json => empl, status: :ok
					else
						error = {code: 19}
						render :json => error, status: :bad_request
					end
				elsif @user.sucursal_id == empl.sucursal_id
					empl.update(active: true, type_id: params[:type_id])
					render :json => empl, status: :ok
				else
					error = {code: 18}
					render :json => error, status: :bad_request
				end
			else
				error = {code: 17}
				render :json => error, status: :bad_request
			end
		else
			error = {code: 16}
			render :json => error, status: :bad_request
		end
	end

	def search_sucursal
		q = params[:search].downcase
		respond = BusinessSucursal.where("name like '#{q}%'")
		render :json => {model: respond}, status: :ok
	end

	private

	def business_params
		params.permit(:business_id, :name, :phone, :address_description, :address_longitude, :address_latitude)
	end

end