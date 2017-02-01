class WelcomeController < ApplicationController

	def index
		en = SymmetricEncryption.encrypt "Sensitive data"
		data = {data: en}
		render :json => {model: data}
	end

end