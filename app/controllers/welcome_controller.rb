class WelcomeController < ApplicationController

	def index
		en = SymmetricEncryption.encrypt "Sensitive data"
		de = SymmetricEncryption.decrypt en
		s3 = Aws::S3::Client.new
		data = {en: en, de: de}
		render :json => {model: data}
	end

end