SampleApp::Application.configure do

  # Settings specified here will take precedence over those in config/application.rb

  ENV['full_host'] = "https://localhost:3000"
  ENV['sfdc_consumer_key'] = "3MVG9y6x0357HlecoJl08HiRMZ338mCb7wYh.oU3IAQe5XqsAPDf6.aFJBx5wPwq2zl9Nck.0Rfb9tFIxwZHu"
  ENV['sfdc_consumer_secret'] = "8914719215705045898"

  ENV['DATABASEDOTCOM_CLIENT_ID'] = "3MVG9y6x0357HlecoJl08HiRMZ338mCb7wYh.oU3IAQe5XqsAPDf6.aFJBx5wPwq2zl9Nck.0Rfb9tFIxwZHu"
  ENV['DATABASEDOTCOM_CLIENT_SECRET'] = "8914719215705045898"


  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
end

