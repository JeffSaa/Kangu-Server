require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module FrepiServer
  class Application < Rails::Application
  	 config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :delete, :options]
      end
    end
  end
end