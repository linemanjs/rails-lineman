require 'rails_lineman/task_helpers'

require 'rails_lineman/meta_lineman_doer'

namespace :assets do
  desc 'Compile all the assets named in config.assets.precompile (Wrapped by rails-lineman)'
  RailsLineman::TaskHelpers.override_task :precompile => :environment do
    begin
      config = Rails.application.config.rails_lineman
      if config.lineman_project_location.present?
        lineman_doer = RailsLineman::MetaLinemanDoer.new(config)
        lineman_doer.precompile_assets
      else
        puts "WARNING: No Lineman project location was set (see: `config.rails_lineman.lineman_project_location`). Skipping Lineman build"
      end

      Rake::Task["assets:precompile:original"].execute
    ensure
      lineman_doer.try(:destroy_assets)
    end
  end
end
