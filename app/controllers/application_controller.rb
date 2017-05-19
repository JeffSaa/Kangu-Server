class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  def upload_blob(blob_name, file, id)
    client = Azure::Storage::Client.create(:storage_account_name => "testblobjeff", :storage_access_key => "M8APPr3vAIJ0bGDXslE5cXqdQLzqd3hve6lQ3WvFoi96xv6IB8alkfSvhmZgYn7PfiBjj5XKhQvsWI/LrlvbDw==")
    blobs = client.blob_client
    Azure::Storage.setup(:storage_account_name => "testblobjeff", :storage_access_key => "M8APPr3vAIJ0bGDXslE5cXqdQLzqd3hve6lQ3WvFoi96xv6IB8alkfSvhmZgYn7PfiBjj5XKhQvsWI/LrlvbDw==")
    blobs = Azure::Storage::Blob::BlobService.new
    blobs.with_filter(Azure::Storage::Core::Filter::ExponentialRetryPolicyFilter.new)
    container = blobs.get_container_metadata(blob_name)
    file_data = file.tempfile
    content = File.open(file_data, 'rb') { |file| file.read }
    blobs.create_block_blob(container.name, id.to_s, content)
  end

  def render_user(user, token = nil)
    response = {token: token, user_info: user, isBusinessEmployee: false, isFrepiAdmin: false, isFrepiSupervisor: false}
    if charge_exist(user, Constants::FREPI_ADMIN)
      response[:isFrepiAdmin] = true
    end
    if charge_exist(user, Constants::FREPI_SUPERVISOR)
      response[:isFrepiSupervisor] = true
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

  def set_paginate_header(response, per_page, model, current_page)
    self.headers['products_per_page'] = per_page
    self.headers['current_page'] = current_page ||= 1
    self.headers['pages_count'] = model.total_pages
    self.headers['total_entries'] = model.total_entries
  end

  def get_product_price(p)
    return p[:product_info][:entry_price] + p[:product_info][:entry_price] * p[:product_info][:business_price] / 100
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

  def show_console(o)
    p "------------- DEBUG -------------"
    p o
    p "------------- DEBUG -------------"    
  end

  private 

  def charge_params
    params.permit(:user_id, :target_id, :type_id)
  end

end