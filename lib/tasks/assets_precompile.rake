require 'rails_lineman/task_helpers'

require 'rails_lineman/lineman_doer'

namespace :assets do
  desc 'Compile all the assets named in config.assets.precompile (Wrapped by rails-lineman)'
  RailsLineman::TaskHelpers.override_task :precompile => :environment do
    begin
      lineman_doer = RailsLineman::LinemanDoer.new(Rails.application.config.rails_lineman)
      lineman_doer.precompile_assets
      Rake::Task["assets:precompile:original"].execute
    ensure
      lineman_doer.destroy_assets
    end
  end
end
