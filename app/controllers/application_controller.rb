class ApplicationController < ActionController::API

	def upload_blob(blob_name, file, id)
		if Rails.env.production?
			client = Azure::Storage::Client.create(:storage_account_name => "kangublobs", :storage_access_key => "PEyVyYYVrIFyC7FfkwqsKlkYqOJknqkZGFp3vGglTW+gHwO5vacOXEXE6i3ZKzKVBPwvQmv7Y2FUxx8xcFX+Wg==")
			blobs = client.blob_client
			Azure::Storage.setup(:storage_account_name => "kangublobs", :storage_access_key => "PEyVyYYVrIFyC7FfkwqsKlkYqOJknqkZGFp3vGglTW+gHwO5vacOXEXE6i3ZKzKVBPwvQmv7Y2FUxx8xcFX+Wg==")
		end
		if Rails.env.development?
			client = Azure::Storage::Client.create(:storage_account_name => "kangublobdev", :storage_access_key => "3rz+hjDqwQILCruDUHmm50dlqWE5mp2PSmgkxd7wYDxFvWcutzNuvckf4enKj2Zzakd5dPuWZrc5yBNlxb6Jcg==")
			blobs = client.blob_client
			Azure::Storage.setup(:storage_account_name => "kangublobdev", :storage_access_key => "3rz+hjDqwQILCruDUHmm50dlqWE5mp2PSmgkxd7wYDxFvWcutzNuvckf4enKj2Zzakd5dPuWZrc5yBNlxb6Jcg==")
		end
		blobs = Azure::Storage::Blob::BlobService.new
		blobs.with_filter(Azure::Storage::Core::Filter::ExponentialRetryPolicyFilter.new)
		container = blobs.get_container_metadata(blob_name)
		file_data = file.tempfile
		content = File.open(file_data, 'rb') { |file| file.read }
		blobs.create_block_blob(container.name, id.to_s, content)
	end

	def render_user(user, token = nil)
		response = {token: token, user_info: user, isBusinessEmployee: false, isKanguAdmin: false, isKanguSupervisor: false}
		if charge_exist(user, Constants::KANGU_ADMIN)
			response[:isKanguAdmin] = true
		end
		if charge_exist(user, Constants::KANGU_SUPERVISOR)
			response[:isKanguSupervisor] = true
		end
		if charge_exist(user, Constants::BUSINESS_OWNER)
			response[:isBusinessEmployee] = true
		end
		if charge_exist(user, Constants::BUSINESS_OPERATOR)
			response[:isBusinessEmployee] = true
		end
		if charge_exist(user, Constants::BUSINESS_CHEF)
			response[:isBusinessEmployee] = true
		end
		if charge_exist(user, Constants::BUSINESS_ADMIN)
			response[:isBusinessEmployee] = true
		end
		render :json => response, status: :ok
	end

	def set_paginate_header(per_page, model, current_page)
		self.headers['entries_per_page'] = per_page
		self.headers['current_page'] = current_page ||= 1
		self.headers['pages_count'] = model.total_pages
		self.headers['total_entries'] = model.total_entries
	end

	def get_product_price(p)
		return p[:entry_price] * p[:business_percent] / 100 + p[:entry_price] + p[:business_gain]
	end

	def render_response_json(code, status)
		render :json => {code: code}, status: status
	end

	def validate_authentification_token
		@token = Token.find_by(id: request.headers["Authorization"])
		if not @token
			render_response_json(100, :bad_request)
		else
			@current_user = User.find_by(id: @token.user_id)
			if not @current_user
				render_response_json(101, :bad_request)
			else
			end
		end   
	end

	def validate_token
		token = Token.find_by(id: request.headers["Authorization"])
		if token
			return User.find_by(id: token.user_id)
		end
	end

	def charge_exist(user, type)
		return Charge.find_by(user_id: user.id, type_id: type)
	end

	def create_charge
		return Charge.new(charge_params)
	end

	def getPlaceOwner(id)
		charge = Charge.find_by(target_id: id, type_id: Constants::BUSINESS_OWNER)
		return User.find(charge.user_id)
	end

	def getSucursalAdmins(id)
		charges = Charge.where(target_id: id, type_id: Constants::BUSINESS_ADMIN)
		admins = []
		charges.each do |c|
			admins << User.find(c.user_id)
		end
		return admins
	end

	def getSucursalPlace(id)
		return BusinessPlace.find(BusinessSucursal.find(id).business_id)
	end

	def show_console(o)
		p "------------- DEBUG -------------"
		p o
		p "------------- DEBUG -------------"    
	end

	def get_orderproduct_info(op)
		variant = ProductVariant.find(op.variant_id)
		product = Product.find(variant.product_id)
		return {order_product: op, variant: variant, product: product}
	end

	def getProvider(p, target, type)
		providers = []
		Charge.where(type_id: Constants::KANGU_PROVIDER, target_id: p).each do |c|
			user = User.find(c.user_id)
			providers << {user: user, provider: Provider.find_by(user_id: user.id)}
		end
		return providers
	end

	private 

	def charge_params
		params.permit(:user_id, :target_id, :type_id)
	end

end