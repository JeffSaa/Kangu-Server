require_relative 'boot'

require 'rails/all'
require 'csv'

Bundler.require(*Rails.groups)

module KanguServer
	class Application < Rails::Application
		config.api_only = true			
		config.middleware.insert_before 0, Rack::Cors do
			allow do
				origins '*'
				resource '*',
				:headers => :any,
				:expose  => ['current_page', 'pages_count', 'products_per_page', 'total_entries'],
				:methods => [:get, :post, :delete, :put]
			end
		end
	end
end