class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token

  private 

  def validate_authentification_token
  	@token = Token.find_by(id: request.headers["Authorization"])
  	if not @token 
  		error = {code: 100}
  		render :json => error, status: :bad_request
  	end 	
  end

end
