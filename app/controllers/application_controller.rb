class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  def upload_blob(blob_name, file)
    client = Azure::Storage::Client.create(:storage_account_name => "jeffblobtest", :storage_access_key => "qp+xrnaMW0W7lWb7U1KO3B4KMclF52ZwPu7zJYCcvmNLzAz9MzfPV2HRH6IWItB3V+HIw1m7+0wUlmV/Xy/YKw==")
    blobs = client.blob_client
    Azure::Storage.setup(:storage_account_name => "jeffblobtest", :storage_access_key => "qp+xrnaMW0W7lWb7U1KO3B4KMclF52ZwPu7zJYCcvmNLzAz9MzfPV2HRH6IWItB3V+HIw1m7+0wUlmV/Xy/YKw==")
    blobs = Azure::Storage::Blob::BlobService.new
    blobs.with_filter(Azure::Storage::Core::Filter::ExponentialRetryPolicyFilter.new)
    container = blobs.get_container_metadata(blob_name)
    file_data = file.tempfile
    content = File.open(file_data, 'rb') { |file| file.read }
    blobs.create_block_blob(container.name, product.id.to_s, content)
  end

  private 

  def validate_authentification_token
  	@token = Token.find_by(id: request.headers["Authorization"])
  	if not @token 
  		error = {code: 100}
  		render :json => error, status: :bad_request
    else
      @user = User.find_by(id: @token.user_id)
      if not @user
        error = {code: 101}
        render :json => error, status: :bad_request
      end
  	end 	
  end

end
