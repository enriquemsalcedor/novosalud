require_relative 'boot'

require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Proyecto
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.time_zone = 'America/Caracas'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #config.action_mailer.default_url_options = { :host => 'correo.sipeca.net' }
    config.action_mailer.default_url_options = { :host => 'correo.novosalud.com.ve' }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.default :charset => 'utf-8'
    #Configuracion de cors
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
    #end
    ActionMailer::Base.smtp_settings = {
      #:address => 'correo.sipeca.net',
      :address => 'correo.novosalud.com.ve',
      :port => 587,
      :authentication => :plain,
      :domain => 'correo.novosalud.com.ve',
      :user_name => 'prevencionline@novosalud.com.ve',
      :password => 'Inicio2017',
      :enable_starttls_auto => false
      #:domain => 'correo.sipeca.net',
      #:user_name => 'mensajeria@sipeca.net',
      #:password => 'Mensajeria-99)',
    }

    config.i18n.default_locale = :es
    config.i18n.locale = :es
    config.active_job.queue_adapter = :deleyed_job
    config.autoload_paths += %W(#{config.root}/lib)#probar

    config.active_record.default_timezone = :local
   # config.action_mailer.default_url_options ={host: 'example.com'}
  config.to_prepare do
    # Or to configure mailer layout
    Devise::Mailer.layout "mailer" # email.haml or email.erb
  end

  end
end

