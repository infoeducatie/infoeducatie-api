require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Infoeducatie
  class Application < Rails::Application
    config.load_defaults 8.1

    config.autoload_lib(ignore: %w[admin])
    config.middleware.use Rack::Deflater

    # Rails 4 did not implicitly validate every belongs_to association. Models
    # that require an association already declare an explicit validation.
    config.active_record.belongs_to_required_by_default = false

    config.i18n.available_locales = %i[en ro]
    config.i18n.default_locale = :en
    config.time_zone = "Bucharest"

    config.generators.system_tests = nil
  end
end
