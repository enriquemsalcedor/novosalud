source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# ****************************************************
# Desarrolladores: en esta seccion deben colocar las
# gemas que instalen con un comentario para que se usa
# gema para las sesiones
gem 'activerecord-session_store'

# gema de postgresql
gem 'pg', '~> 0.19'
# gema para manejar la transiciones entre estatus
gem 'aasm', '~> 4.11', '>= 4.11.1'
# gema para autorizacion de acceso
gem 'devise'
gem 'devise_security_extension', '~> 0.9.2'
# gema que permite crear migraciones de datos
gem 'seed_migration'
# gema para cargar archivos
gem 'paperclip', '~> 5.1'
# Para guardar las imagenes y mantenga la respuesta JS.
gem 'remotipart', '~> 1.3', '>= 1.3.1'
# Para trabajar las relaciones muchos a muchos
gem 'cocoon', '~> 1.2', '>= 1.2.9'

# Para validar los campos y mostrar los mensajes
gem 'client_side_validations', '~> 9.1'

gem 'nested_form'
#Gemas para el xls
gem 'rubyzip', '~> 1.1.0'
gem 'axlsx', '2.1.0.pre'
gem 'axlsx_rails'
#*********
gem 'ransack', '~> 1.8', '>= 1.8.2'
gem 'rails-backup-migrate'
#gema para el cierre automatico de la sesiones
gem 'auto-session-timeout'
#gema para validar el formato de una direccion web y que sea valido
gem "validate_url"
# ***************************************************
# Gemas para Look And Feel
gem 'bootstrap-sass'
gem 'autoprefixer-rails'
gem 'nivo-rails'
# ****************************************************
gem 'auto_increment', '~> 1.4'
#gema para generar pdf
gem 'wicked_pdf'
#Complemento de gema de wicked_pdf
gem 'wkhtmltopdf-binary', '~> 0.9.9.3'

gem 'delayed_job_active_record', '~> 4.1', '>= 4.1.1'
gem 'daemons'
gem "breadcrumbs_on_rails"

gem 'rack-cors', :require => 'rack/cors'
# ****************************************************
# Gema para el paginado
gem 'will_paginate'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use sqlite3 as the database for Active Record
# gem 'sqlite3'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# gema para el manejo de validaciones de fecha
#Look and Feel
gem 'jquery-datatables-rails'
gem 'chosen-rails'
gem 'twitter-typeahead-rails'

#Gema para la fechas
gem 'bootstrap-datepicker-rails'
gem 'validates_timeliness', '~> 4.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
