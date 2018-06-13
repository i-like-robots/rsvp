require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rsvp
  class Application < Rails::Application
    # Add lib to autoload path
    config.autoload_paths << Rails.root.join('lib')
  end
end
