source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'jbuilder', '~> 2.5'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'symmetric-encryption'
gem 'rack-cors', :require => 'rack/cors'
gem 'azure-storage'
gem 'activerecord-deprecated_finders'
gem 'will_paginate'
gem "roo", "~> 2.7.0"
gem 'convertloop', '0.1.2'
gem 'net_http_ssl_fix'
gem 'openpayu'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
end