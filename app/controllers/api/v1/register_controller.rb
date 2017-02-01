class Api::V1::RegisterController < ApplicationController

	def create
		render :json => {model: "hola"}
	end

	def index
		en = SymmetricEncryption.encrypt "Sensitive data"
		de = SymmetricEncryption.decrypt en
		data = {en: en, de: de}
		render :json => {model: data}
	end

end