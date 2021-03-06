require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(assets: %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Joblr
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib/validators #{config.root}/lib/initializers)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :object_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('locales', '**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Devise: forces the application to not access the DB or load models when
    # precompiling your assets. Good idea when deploying Rails 3.1 on Heroku.
    config.assets.initialize_on_precompile = false

    # Postmark emailing configuration
    config.action_mailer.delivery_method   = :postmark
    config.action_mailer.postmark_settings = {api_key: '0d3b84d0-f242-4ab2-b986-13a536d889a2'}

    # Exceptions handling in app routes
    config.exceptions_app = self.routes

    # Generators
    config.generators do |g|
      g.orm                 :active_record
      g.test_framework      :rspec, fixture: true, views: false, helpers: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.template_engine :haml
    end

    # Removes the default rails error handling on input and label
    # Relies on the Nokogiri gem.
    # Credit to https://github.com/ripuk
    config.field_error_proc = Proc.new do |html_tag, instance|
      html = %(<div class="field_with_errors">#{html_tag}</div>).html_safe
      elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css "label, input"
      elements.each do |e|
        if e.node_name.eql? 'label'
          html = %(#{e}).html_safe
        elsif e.node_name.eql? 'input'
          html = %(#{e}).html_safe
        end
      end
      html
    end
  end
end
