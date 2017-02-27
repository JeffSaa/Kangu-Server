class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  def upload_blob(blob_name, file, id)
    client = Azure::Storage::Client.create(:storage_account_name => "frepiblobs", :storage_access_key => "IK9Plttm3fkAXZhcz0rig2ZD6GwyDUwIrtKBz1Lm0nr6hZuduVN9ktdWaFmrplyBdK/L5mwjueLloqM87cTP4A==")
    blobs = client.blob_client
    Azure::Storage.setup(:storage_account_name => "frepiblobs", :storage_access_key => "IK9Plttm3fkAXZhcz0rig2ZD6GwyDUwIrtKBz1Lm0nr6hZuduVN9ktdWaFmrplyBdK/L5mwjueLloqM87cTP4A==")
    blobs = Azure::Storage::Blob::BlobService.new
    blobs.with_filter(Azure::Storage::Core::Filter::ExponentialRetryPolicyFilter.new)
    container = blobs.get_container_metadata(blob_name)
    file_data = file.tempfile
    content = File.open(file_data, 'rb') { |file| file.read }
    blobs.create_block_blob(container.name, id.to_s, content)
  end

  def user_belong_to_sucursal(user_id, sucursal_id)
    user = User.find_by(id: user_id)
    sucursal = BusinessSucursal.find_by(id: sucursal_id)
    if user && sucursal
      business = BusinessPlace.find_by(id: sucursal.business_id)
      render :json => business, status: :ok
    else
      error = {code: 102}
      render :json => error, status: :bad_request
    end
    return false
  end

  def set_paginate_header(response, per_page, model, current_page)
    self.headers['products_per_page'] = per_page
    self.headers['current_page'] = current_page ||= 1
    self.headers['pages_count'] = model.total_pages
    self.headers['total_entries'] = model.total_entries
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