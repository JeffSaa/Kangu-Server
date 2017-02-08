class Api::V1::Products::ProductController < ApplicationController
	before_action :validate_authentification_token

	def create
		if @token
			if @user
				if @user.type_id < 4
					product = Product.new(product_params)
					if product.save
						client = Azure::Storage::Client.create(:storage_account_name => "jeffblobtest", :storage_access_key => "qp+xrnaMW0W7lWb7U1KO3B4KMclF52ZwPu7zJYCcvmNLzAz9MzfPV2HRH6IWItB3V+HIw1m7+0wUlmV/Xy/YKw==")
						blobs = client.blob_client
						Azure::Storage.setup(:storage_account_name => "jeffblobtest", :storage_access_key => "qp+xrnaMW0W7lWb7U1KO3B4KMclF52ZwPu7zJYCcvmNLzAz9MzfPV2HRH6IWItB3V+HIw1m7+0wUlmV/Xy/YKw==")
						blobs = Azure::Storage::Blob::BlobService.new
						blobs.with_filter(Azure::Storage::Core::Filter::ExponentialRetryPolicyFilter.new)
						container = blobs.get_container_metadata("fotoscontainer")
						file_data = params[:photo].tempfile
						content = File.open(file_data, 'rb') { |file| file.read }
						blobs.create_block_blob(container.name, product.id.to_s, content)
						render :json => product, status: :ok
					else
						error = {code: 21}
						render :json => error, status: :bad_request
					end
				else
					error = {code: 20}
					render :json => error, status: :bad_request
				end
			end
		end
	end

	private

	def product_params
		params.permit(:name, :group_id, :entry_price, :natural_price, :business_price, :subcategorie_id,
			:enabled, :coin_price, :discount, :provider_may_id, :provider_min_id, :type_size, :cant_min_may)
	end

end