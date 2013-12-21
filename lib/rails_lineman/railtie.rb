module RailsLineman
  class Railtie < Rails::Railtie
    config.rails_lineman = ActiveSupport::OrderedOptions.new

    config.rails_lineman.lineman_project_location = ENV['LINEMAN_PROJECT_LOCATION']
    config.rails_lineman.javascripts_destination = File.join("app", "assets","javascripts", "lineman")
    config.rails_lineman.stylesheets_destination = File.join("app", "assets","stylesheets", "lineman")
    config.rails_lineman.remove_lineman_assets_after_asset_pipeline_precompilation = true

    rake_tasks do
      load(File.join(File.dirname(__FILE__), '..', 'tasks', 'assets_precompile.rake'))
    end
  end
end
