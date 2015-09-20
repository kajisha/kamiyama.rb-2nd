require File.expand_path('../boot', __FILE__)

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'neo4j/railtie'

Bundler.require(*Rails.groups)

module FavAnime
  class Application < Rails::Application
    config.time_zone = 'Asia/Tokyo'

    config.i18n.default_locale = :en

    config.generators do |g|
      g.orm :neo4j
    end

    config.neo4j.session_type = :server_db
    config.neo4j.session_path = ENV['NEO4J_URL'] || 'http://localhost:7474'
  end
end
