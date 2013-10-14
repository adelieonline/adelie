Adelie::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  config.stripe_api_key = 'sk_test_L7tarpEirs85dm95NoxRMmQW'
  config.stripe_publishable_key = 'pk_test_VDibhwkeKEdInW1tMaW5fseP'
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => 'adeliedevelopment',
      :access_key_id => 'AKIAJVFLZNXW6TZZ3USA',
      :secret_access_key => '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'
    },
    :url => ':s3_domain_url',
    :path => '/:class/:attachment/:id_partition/:style/:filename'
  }
  config.s3_bucket = 'adeliedevelopment'
end
